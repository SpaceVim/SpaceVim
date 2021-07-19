(in-package #:cl-user)


(defpackage #:aio-sbcl
  (:use #:cl
        #:sb-sys
        #:sb-bsd-sockets
        #:sb-introspect)
  (:export #:*fd-map*
           #:*static-buffer*
           #:aio-error
           #:aio-error-afd
           #:aio-error-code
           #:aio-error-where
           #:aio-fd
           #:aio-fd-fd
           #:aio-fd-socket
           #:aio-fd-parent
           #:aio-fd-write-buffer
           #:aio-fd-read-handle
           #:aio-fd-write-handle
           #:aio-fd-read-cb
           #:aio-fd-write-cb
           #:aio-fd-error-cb
           #:aio-fd-write
           #:aio-fd-close
           #:aio-fd-enable-read-handle
           #:aio-fd-disable-read-handle
           #:aio-fd-enable-write-handle
           #:aio-fd-disable-write-handle
           #:with-event-loop
           #:tcp-connect
           #:tcp-server))


(in-package #:aio-sbcl)


(defvar *fd-map* nil)
(defvar *static-buffer* nil)


(define-condition aio-error (error)
  ((afd
     :initarg :afd
     :initform nil
     :reader aio-error-afd)
   (code
     :initarg :code
     :initform nil
     :reader aio-error-code)
   (where
     :initarg :where
     :initform nil
     :reader aio-error-where)))


(defclass aio-fd ()
  ((fd
     :initarg :fd
     :initform nil
     :accessor aio-fd-fd)
   (socket
     :initarg :socket
     :initform nil
     :accessor aio-fd-socket)
   (parent
     :initarg :parent
     :initform nil
     :accessor aio-fd-parent)
   (write-buffer
     :initarg :write-buffer
     :initform nil
     :accessor aio-fd-write-buffer)
   (read-handle
     :initarg :read-handle
     :initform nil
     :accessor aio-fd-read-handle)
   (write-handle
     :initarg :write-handle
     :initform nil
     :accessor aio-fd-write-handle)
   (read-cb
     :initarg :read-cb
     :initform nil
     :accessor aio-fd-read-cb)
   (write-cb
     :initarg :write-cb
     :initform nil
     :accessor aio-fd-write-cb)
   (error-cb
     :initarg :error-cb
     :initform nil
     :accessor aio-fd-error-cb)))


(defgeneric aio-fd-write (afd data)
  (:method ((afd aio-fd) data)
    (with-slots (fd write-buffer write-handle) afd
      (setf write-buffer (append write-buffer (list data)))
      (aio-fd-enable-write-handle afd))))


(defgeneric aio-fd-close (afd)
  (:method ((afd aio-fd))
    (aio-fd-disable-read-handle afd)
    (aio-fd-disable-write-handle afd)
    (with-slots (fd socket) afd
      (when socket
        (socket-close socket))
      (remhash fd *fd-map*))))


(defgeneric aio-fd-enable-read-handle (afd)
  (:method ((afd aio-fd))
    (vom:debug "aio-fd-enable-read-handle: ~s" (aio-fd-fd afd))
    (with-slots (fd read-handle) afd
      (when (not read-handle)
        (setf read-handle (add-fd-handler fd :input #'socket-input-cb))))))


(defgeneric aio-fd-disable-read-handle (afd &key clear-cb)
  (:method ((afd aio-fd) &key (clear-cb nil))
    (vom:debug "aio-fd-disable-read-handle: ~s" (aio-fd-fd afd))
    (with-slots (read-handle read-cb) afd
      (when clear-cb
        (setf read-cb nil))
      (when read-handle
        (remove-fd-handler read-handle)
        (setf read-handle nil)))))


(defgeneric aio-fd-enable-write-handle (afd)
  (:method ((afd aio-fd))
    (vom:debug "aio-fd-enable-write-handle: ~s" (aio-fd-fd afd))
    (with-slots (fd write-handle) afd
      (when (not write-handle)
        (setf write-handle (add-fd-handler fd :output #'socket-output-cb))))))


(defgeneric aio-fd-disable-write-handle (afd &key clear-cb)
  (:method ((afd aio-fd) &key (clear-cb nil))
    (vom:debug "aio-fd-disable-write-handle: ~s" (aio-fd-fd afd))
    (with-slots (write-handle write-cb) afd
      (when clear-cb
        (setf write-cb nil))
      (when write-handle
        (remove-fd-handler write-handle)
        (setf write-handle nil)))))


(defmacro with-event-loop (&body body)
  `(let ((*fd-map* (make-hash-table))
         (*static-buffer* (make-array 4096 :element-type '(unsigned-byte 8))))
     ,@body
     (loop for event-handled = (serve-event)
          when (not event-handled) return nil)))


(defun tcp-connect (host port &key read-cb write-cb error-cb)
  (let* ((socket (make-instance 'inet-socket :type :stream :protocol :tcp))
         (fd (socket-file-descriptor socket))
         (afd (make-instance 'aio-fd
                             :fd fd
                             :socket socket
                             :read-cb read-cb
                             :write-cb write-cb
                             :error-cb error-cb)))
    (setf (non-blocking-mode socket) t)
    (handler-case
      (socket-connect socket host port)
      (operation-in-progress ()
        (setf (aio-fd-write-handle afd)
              (add-fd-handler fd :output #'socket-connect-cb)))
      (socket-error (c)
        (aio-fd-close afd)
        (error c)))
    (setf (gethash fd *fd-map*) afd)))


(defun tcp-server (host port &key
                   backlog
                   client-read-cb
                   client-write-cb
                   client-error-cb)
  (let ((server-socket
          (make-instance 'inet-socket :type :stream :protocol :tcp)))
    (setf (non-blocking-mode server-socket) t)
    (setf (sockopt-reuse-address server-socket) t)
    (handler-case
      (progn
        (socket-bind server-socket host port)
        (socket-listen server-socket (or backlog 128))
        (let* ((fd (socket-file-descriptor server-socket))
               (afd (make-instance 'aio-fd
                                   :fd fd
                                   :socket server-socket
                                   :read-cb #'(lambda (afd)
                                                (server-accept-cb
                                                  afd
                                                  client-read-cb
                                                  client-write-cb
                                                  client-error-cb))
                                   :error-cb #'socket-error-cb)))
          (aio-fd-enable-read-handle afd)
          (setf (gethash fd *fd-map*) afd)))
      (t (c)
         (socket-close server-socket)
         (error c)))))


(defun arity (fn)
  (let ((arglist (function-lambda-list fn)))
    (or (loop for arg in arglist
              for idx = 0 then (1+ idx)
              when (and (> (length (symbol-name arg)) 0)
                        (eql (elt (symbol-name arg) 0) #\&))
              return idx)
        (length arglist))))


(defun socket-receive-data (socket buf &optional (data-list nil))
  (multiple-value-bind (data data-len peer-host peer-port)
                       (socket-receive socket buf nil)
    (declare (ignore peer-host peer-port))
    ; NOTE: When there's no data at all, DATA and DATA-LEN would be NIL.
    (when (and data data-len (> data-len 0))
      (push (subseq data 0 data-len) data-list))
    (if (or (not data) (not data-len) (< data-len (length buf)))
      (apply #'concatenate
             '(vector (unsigned-byte 8))
             (reverse data-list))
      (socket-receive-data socket buf data-list))))


(defun socket-input-cb (fd)
  (let ((afd (gethash fd *fd-map*)))
    (when afd
      (with-slots (socket read-cb error-cb) afd
        (labels ((handle-condition (c)
                   (aio-fd-disable-read-handle afd)
                   (when error-cb
                     (funcall error-cb afd c)))
                 (call-read-cb (&rest args)
                   (handler-case (apply read-cb args)
                     (t (c)
                       (handle-condition c)))))
          (let ((cb-arity (arity read-cb)))
            (ecase cb-arity
              (1 (call-read-cb afd))
              (2 (let ((data (socket-receive-data socket *static-buffer*)))
                   (if (> (length data) 0)
                     (call-read-cb afd data)
                     (handle-condition
                       (make-condition 'aio-error
                                       :afd afd
                                       :where `(socket-input-cb, fd)
                                       :code :eof))))))))))))


(defun socket-output-cb (fd)
  (let ((afd (gethash fd *fd-map*)))
    (when afd
      (with-slots (socket write-buffer write-cb error-cb) afd
        (labels ((write-buffered ()
                   (vom:debug ">>>>>>>>> ~s: write-buffered" fd)
                   (let ((data (pop write-buffer)))
                     (if data
                       (let ((bytes-written
                               (handler-case
                                 (socket-send socket data nil)
                                 (t (c)
                                   (handle-condition c)
                                   0))))
                         (vom:debug ">>>>>>>>> ~s: bytes-to-write: ~s, bytes-written: ~s"
                                    fd (length data) bytes-written)
                         (if (< bytes-written (length data))
                           (progn
                             (push (subseq data bytes-written) write-buffer)
                             nil)
                           (write-buffered)))
                       t)))
                 (handle-condition (c)
                   (vom:debug ">>>>>>>>> ~s: handle-condition: ~s" fd c)
                   (aio-fd-disable-write-handle afd)
                   (when error-cb
                     (funcall error-cb afd c)))
                 (call-write-cb ()
                   (handler-case
                     (let ((to-write (funcall write-cb afd)))
                       (when to-write
                         (let ((bytes-written
                                 (handler-case
                                   (socket-send socket to-write nil)
                                   (t (c)
                                     (handle-condition c)
                                     (length to-write)))))
                           (when (< bytes-written (length to-write))
                             (setf write-buffer
                                   (append write-buffer
                                           (list (subseq to-write bytes-written))))))))
                     (t (c)
                       (handle-condition c)))))
          (when (write-buffered)
            (if write-cb
              (call-write-cb)
              (progn
                (vom:debug "~s: Nothing to write." (aio-fd-fd afd))
                (aio-fd-disable-write-handle afd)))))))))


(defun socket-connect-cb (fd)
  (let ((afd (gethash fd *fd-map*)))
    (when afd
      (with-slots (read-cb write-cb write-buffer) afd
        (vom:debug "fd ~s: Connected" fd)
        (aio-fd-disable-write-handle afd)
        (when read-cb
          (aio-fd-enable-read-handle afd))
        (when (or write-cb write-buffer)
          (aio-fd-enable-write-handle afd))))))


(defun server-accept-cb (afd client-read-cb client-write-cb client-error-cb)
  (with-slots (socket) afd
    (let ((client-socket (socket-accept socket)))
      (setf (non-blocking-mode client-socket) t)
      (let* ((client-fd (socket-file-descriptor client-socket))
             (client-afd
               (make-instance 'aio-fd
                              :fd client-fd
                              :socket client-socket
                              :parent afd
                              :read-cb client-read-cb
                              :write-cb client-write-cb
                              :error-cb client-error-cb)))
        (when client-read-cb
          (aio-fd-enable-read-handle client-afd))
        (when client-write-cb
          (aio-fd-enable-write-handle client-afd))
        (setf (gethash client-fd *fd-map*) client-afd)))))


(defun socket-error-cb (afd condition)
  (vom:debug "socket-error-cb: ~s: ~s" (aio-fd-fd afd) condition)
  (aio-fd-close afd))
