(in-package #:cl-user)

(defpackage #:aio-sbcl-test
  (:use #:cl
        #:prove
        #:aio-sbcl))

(in-package #:aio-sbcl-test)


(plan 9)

(defun init-globals ()
  (setf aio-sbcl:*fd-map* (make-hash-table))
  (setf aio-sbcl:*static-buffer* (make-array 4096 :element-type '(unsigned-byte 8)))
  (values))

(defun gen-port ()
  (random (+ (- 65000 2048) 2048)))

(defun serve-all-events ()
  ; XXX: 0.2 is an arbitrary number
  (loop for ret = (sb-sys:serve-all-events 0.2)
        when (not ret) return nil))

(defun encode-string (str)
  (concatenate '(vector (unsigned-byte 8))
               (sb-ext:string-to-octets str)))

(defun decode-octets (vec)
  (sb-ext:octets-to-string vec))

(init-globals)


(let ((read-flag nil)
      (error-flag nil)
      (cond-flag nil))
  (let ((afd (tcp-connect #(127 0 0 1) 65535
                          :read-cb #'(lambda (afd data)
                                       (declare (ignore afd data))
                                       (setf read-flag t))
                          :error-cb #'(lambda (afd c)
                                        (declare (ignore afd c))
                                        (setf error-flag t)))))
    (handler-case
      (serve-all-events)
      (sb-bsd-sockets:connection-refused-error ()
        (aio-fd-disable-read-handle afd)
        (aio-fd-disable-write-handle afd)
        (setf cond-flag t)))

    (ok (not read-flag) "tcp-connect - read-cb not called for failed connection")
    (ok (not error-flag) "tcp-connect - error-cb not called for failed connection")
    (ok cond-flag "tcp-connect - connection refused")
    
    (aio-fd-close afd)))


(let ((server-port (gen-port))
      (client-connected-afd nil)
      (client-data nil)
      (server-condition nil)
      (client-condition nil))
  (let ((server-afd (tcp-server #(127 0 0 1) server-port
                                :backlog 128
                                :client-read-cb #'(lambda (afd data)
                                                    (declare (ignore afd))
                                                    (setf client-data (decode-octets data)))
                                :client-write-cb #'(lambda (afd)
                                                     (setf client-connected-afd afd)
                                                     (aio-fd-disable-write-handle afd :clear-cb t))
                                :client-error-cb #'(lambda (afd c)
                                                     (declare (ignore afd))
                                                     (setf server-condition c)))))
    (serve-all-events)
    (let ((client-afd (tcp-connect #(127 0 0 1) server-port
                                   :read-cb #'(lambda (afd data)
                                                (declare (ignore afd))
                                                (setf client-data (decode-octets data)))
                                   :error-cb #'(lambda (afd c)
                                                 (declare (ignore afd c))))))
      (serve-all-events)
      (ok client-connected-afd "tcp-server - client-write-cb called")

      (aio-fd-write client-afd (encode-string "dummy"))
      (serve-all-events)
      (ok (equal client-data "dummy") "tcp-server - client-read-cb called")

      (aio-fd-write client-connected-afd (encode-string "dummy from server"))
      (serve-all-events)
      (ok (equal client-data "dummy from server") "tcp-connect - read-cb called")

      (aio-fd-close client-afd)
      (aio-fd-write client-connected-afd (encode-string "blah"))
      (serve-all-events)
      (ok server-condition "tcp-server - client-error-cb called")

      (aio-fd-close client-connected-afd)

      (setf client-afd
            (tcp-connect #(127 0 0 1) server-port
                         :read-cb #'(lambda (afd data)
                                      (declare (ignore afd))
                                      (setf client-data (decode-octets data)))
                         :error-cb #'(lambda (afd c)
                                       (declare (ignore afd))
                                       (setf client-condition c))))
      (serve-all-events)
      (ok client-connected-afd "tcp-server - client-write-cb called 2")

      (aio-fd-close client-connected-afd)
      (aio-fd-write client-afd (encode-string "blah"))
      (serve-all-events)
      (ok client-condition "tcp-connect - error-cb called")

      (aio-fd-close client-afd))
    (aio-fd-close server-afd)))


(finalize)
