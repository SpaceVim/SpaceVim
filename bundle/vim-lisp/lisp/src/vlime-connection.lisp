(in-package #:cl-user)

(defpackage #:vlime-connection
  (:use #:cl)
  (:export #:*connections*
           #:connection
           #:connection-socket
           #:connection-peer
           #:make-connection
           #:lookup-connection
           #:count-connections
           #:connection-close
           #:ensure-peer-connection))

(in-package #:vlime-connection)


(defvar *connections* nil)


(defclass connection ()
  ((socket
     :accessor connection-socket
     :initarg :socket
     :initform nil)
   (peer
     :accessor connection-peer
     :initarg :peer
     :initform nil)))


(defun make-connection (&rest args)
  (let ((new-conn (apply #'make-instance 'connection args))
        (socket (getf args :socket))
        (peer (getf args :peer)))
    (when peer
      (setf (connection-peer peer) new-conn))
    (when socket
      (setf (gethash socket *connections*) new-conn))
    new-conn))


(defun lookup-connection (socket)
  (gethash socket *connections*))


(defun count-connections ()
  (hash-table-count *connections*))


(defgeneric connection-close (connection)
  (:method ((connection connection))
   (with-slots (socket peer) connection
     (when peer
       (vom:debug "Closing peer connection...")
       (setf (connection-peer peer) nil)
       (connection-close peer))
     (remhash socket *connections*))))


(defun ensure-peer-connection (conn connect-func)
  (with-slots (peer) conn
    (when (not peer)
      (vom:debug "Connecting to peer...")
      (let ((peer-socket (funcall connect-func)))
        (make-connection :socket peer-socket :peer conn)
        (vom:debug "Connection count: ~s" (count-connections))))))
