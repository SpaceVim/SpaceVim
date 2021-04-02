(in-package #:cl-user)

(defpackage #:vlime-usocket
  (:use #:cl
        #:usocket
        #:vlime-protocol))

(in-package #:vlime-usocket)


(defun server-listener (socket swank-host swank-port dont-close)
  (vom:info "Server created: ~s" (multiple-value-list (get-local-name socket)))
  (loop
    (handler-case
      (let ((client-socket (socket-accept socket)))
        (swank/backend:spawn
          #'(lambda ()
              (vlime-control-thread
                client-socket swank-host swank-port))
          :name "Vlime Control Thread")
        (unless dont-close
          (socket-close socket)
          (return-from server-listener)))
      (t (c)
         (vom:error "server-listener: ~a" c)
         (socket-close socket)
         (vom:error "Listener socket stopped." c)
         (return-from server-listener)))))


(defun vlime-control-thread (client-socket swank-host swank-port)
  (vom:info "New client: ~s" client-socket)

  (let* ((control-thread (swank/backend:current-thread))
         (swank-socket
           (handler-case
             (socket-connect swank-host swank-port
                             :protocol :stream
                             :element-type '(unsigned-byte 8))
             (t (c)
                (vom:error "Failed to connect to SWANK: ~s ~s: ~a"
                           swank-host swank-port c)
                (socket-close client-socket)
                (return-from vlime-control-thread))))
         (client-stream (socket-stream client-socket))
         (swank-stream (socket-stream swank-socket)))

    (labels ((read-client-data (buf)
               (loop for byte = (read-byte client-stream)
                     when (not (eql byte (char-code #\linefeed)))
                       do (vector-push-extend byte buf)
                     else
                       return buf))

             (client-read-loop (&optional (data-buf (make-array 0
                                                                :element-type '(unsigned-byte 8)
                                                                :adjustable t
                                                                :fill-pointer 0)))
               (handler-case
                 (swank/backend:send control-thread
                                     `(:client-data ,(copy-seq (read-client-data data-buf))))
                 (t (c)
                    (swank/backend:send control-thread `(:client-eof ,c))
                    (return-from client-read-loop)))
               (client-read-loop))

             (read-swank-data (buf)
               (let ((read-len (read-sequence buf swank-stream)))
                 (if (< read-len (length buf))
                   (progn
                     (swank/backend:send control-thread `(:swank-eof))
                     nil)
                   read-len)))

             (swank-read-loop (&optional (msg-len-buf (make-array
                                                        +swank-msg-len-size+
                                                        :element-type '(unsigned-byte 8))))
               (handler-case
                 (if (read-swank-data msg-len-buf)
                   (let* ((msg-len (parse-swank-msg-len msg-len-buf))
                          (msg-buf (make-array msg-len :element-type '(unsigned-byte 8))))
                     (when (read-swank-data msg-buf)
                       (swank/backend:send control-thread `(:swank-data ,msg-buf))))
                   (return-from swank-read-loop))
                 (t (c)
                    (swank/backend:send control-thread `(:swank-eof ,c))
                    (return-from swank-read-loop)))
               (swank-read-loop msg-len-buf)))

      (let ((client-read-thread (swank/backend:spawn
                                  #'client-read-loop
                                  :name "Vlime Client Reader"))
            (swank-read-thread (swank/backend:spawn
                                 #'swank-read-loop
                                 :name "Vlime SWANK Reader")))
        (loop
          (let ((msg (swank/backend:receive)))
            (ecase (car msg)
              (:client-data
                (vom:debug "client-data msg")
                (handler-case
                  (let ((line (swank/backend:utf8-to-string (nth 1 msg))))
                    (vom:debug "Message from client: ~s" line)
                    (write-sequence (msg-client-to-swank line :octets)
                                    swank-stream)
                    (finish-output swank-stream))
                  (t (c)
                     (swank/backend:send control-thread `(:client-data-error ,c)))))

              (:swank-data
                (vom:debug "swank-data msg")
                (handler-case
                  (let ((swank-msg (swank/backend:utf8-to-string (nth 1 msg))))
                    (vom:debug "Message from SWANK: ~s" swank-msg)
                    (write-sequence (msg-swank-to-client swank-msg :octets)
                                    client-stream)
                    (finish-output client-stream))
                  (t (c)
                     (swank/backend:send control-thread `(:swank-data-error ,c)))))

              ((:exit :client-eof :swank-eof :client-data-error :swank-data-error)
                (vom:info "Control thread stopping: ~s" msg)
                (let ((thread-list (list swank-read-thread
                                         client-read-thread))
                      (current-thread (swank/backend:current-thread)))
                  (dolist (thread thread-list)
                    (when (and (swank/backend:thread-alive-p thread)
                               (not (equal current-thread thread)))
                      (swank/backend:kill-thread thread))))
                (let ((stream-list (list swank-stream client-stream)))
                  (dolist (stream stream-list)
                    (close stream)))
                (return-from vlime-control-thread)))))))))


(in-package #:vlime)

(defmethod start-server ((backend (eql :usocket)) host port swank-host swank-port dont-close)
  (vom:config t :info)
  (let* ((server-socket
           (usocket:socket-listen host port
                                  :reuse-address t
                                  :backlog 128
                                  :element-type '(unsigned-byte 8)))
         (local-name (multiple-value-list (usocket:get-local-name server-socket))))
    (values
      (swank/backend:spawn
        #'(lambda ()
            (vlime-usocket::server-listener server-socket swank-host swank-port dont-close))
        :name (format nil "Vlime Server Listener ~a ~a" (first local-name) (second local-name)))
      local-name)))
