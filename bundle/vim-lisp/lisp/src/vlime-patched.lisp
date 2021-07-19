(in-package #:cl-user)

(defpackage #:vlime-patched
  (:use #:cl
        #:vlime-protocol)
  (:export #:patch-swank))

(in-package #:vlime-patched)


(defun make-buffer ()
  (make-array 0
              :element-type '(unsigned-byte 8)
              :adjustable t
              :fill-pointer 0))

(defun read-binary-line (stream &optional (buf (make-buffer)))
  (loop for byte = (read-byte stream)
        when (not (eql byte (char-code #\linefeed)))
          do (vector-push-extend byte buf)
        else
          ; ECL needs BUF to be coerced.
          ; It may not be necessary for other implementations.
          return (coerce buf '(vector (unsigned-byte 8)))))

(defun read-message (stream package)
  (let* ((bin-line (read-binary-line stream))
         (line (swank/backend:utf8-to-string bin-line))
         (json (yason:parse line)))
    ; We dump and read the form again,
    ; to get the extra behaviors of READ-FORM.
    ; Some implementations won't work without this.
    (let ((form
            (swank/rpc::read-form
              (swank/rpc::prin1-to-string-for-emacs
                (json-to-form json) package)
              package)))
      (if (client-emacs-rex-p form)
        (seq-client-to-swank form)
        (remove-client-seq form)))))

(defun write-message (message package stream)
  (let* ((*package* package)
         (json (form-to-json message)))
    (if (eql (car message) :return)
      (setf json (seq-swank-to-client json))
      (setf json (list 0 json)))
    (let* ((encoded (with-output-to-string (json-out)
                      (yason:encode json json-out)))
           (full-line (concatenate
                        'string encoded (format nil "~c~c" #\return #\linefeed)))
           (bin-line (swank/backend:string-to-utf8 full-line)))
      (write-sequence bin-line stream)
      (finish-output stream))))

;; This function essentially reads a VLIME-RAW-MSG. Currently messages of this
;; type are only used for ".slime-secret" authentication.
(defun read-packet (stream)
  (let* ((bin-line (read-binary-line stream))
         (line (swank/backend:utf8-to-string bin-line))
         (json (yason:parse line)))
    (let ((form
            (swank/rpc::read-form
              (swank/rpc::prin1-to-string-for-emacs
                (json-to-form json) swank::*swank-io-package*)
              swank::*swank-io-package*)))
      (nth 1 (nth 1 form)))))

(defun patch-swank ()
  (setf (symbol-function 'swank/rpc:read-message) (symbol-function 'read-message)
        (symbol-function 'swank/rpc:write-message) (symbol-function 'write-message)
        (symbol-function 'swank/rpc:read-packet) (symbol-function 'read-packet))
  (values))
