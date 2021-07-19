(in-package #:cl-user)

(defpackage #:vlime-protocol
  (:use #:cl)
  (:export #:+swank-msg-len-size+
           #:parse-form
           #:write-form
           #:seq-client-to-swank
           #:seq-swank-to-client
           #:client-emacs-rex-p
           #:remove-client-seq
           #:form-to-json
           #:json-to-form
           #:msg-client-to-swank
           #:msg-swank-to-client
           #:parse-line
           #:parse-swank-msg-len
           #:parse-swank-msg))

(in-package #:vlime-protocol)


(defparameter +swank-msg-len-size+ 6)


(defun parse-form (input-str)
  (with-standard-io-syntax
    (let ((*read-eval* nil)
          (*package* swank::*swank-io-package*))
      (read-from-string input-str))))


(defun write-form (form)
  (with-standard-io-syntax
    (let ((*package* swank::*swank-io-package*))
      (write-to-string form :case :downcase))))


(defun seq-client-to-swank (form)
  (let ((seq (car form))
        (payload (cadr form)))
    (concatenate 'list payload (list seq))))


(defun seq-swank-to-client (form)
  (let ((seq (car (last form)))
        (payload (subseq form 0 (1- (length form)))))
    (list seq payload)))


(defun client-emacs-rex-p (form)
  (and (listp form)
       (listp (nth 1 form))
       (eql (car (nth 1 form)) :emacs-rex)))


(defun client-raw-msg-p (form)
  (and (listp form)
       (listp (nth 1 form))
       (eql (car (nth 1 form)) :vlime-raw-msg)))


(defun remove-client-seq (form)
  (nth 1 form))


(defun list-form-to-json (list &optional (acc (list)))
  (if list
    (if (listp list)
      (progn
        (push (form-to-json (car list)) acc)
        (list-form-to-json (cdr list) acc))
      (let ((obj (make-hash-table :test #'equal)))
        (setf (gethash "head" obj) (reverse acc))
        (setf (gethash "tail" obj) list)
        obj))
    (reverse acc)))


(defun form-to-json (form)
  (cond
    ((listp form)
     (list-form-to-json form))
    ((eql form t)
     ; special case to prevent T from being serialized as a normal symbol,
     ; thus saving some space
     form)
    ((symbolp form)
     (let ((sym-obj (make-hash-table :test #'equal))
           (sym-name (symbol-name form))
           (sym-package (package-name (symbol-package form))))
       (setf (gethash "name" sym-obj) sym-name)
       (setf (gethash "package" sym-obj) sym-package)
       sym-obj))
    (t
     ; Numbers & strings
     form)))


(defun set-last-cdr (list obj)
  (if (and (cdr list) (listp (cdr list)))
    (set-last-cdr (cdr list) obj)
    (setf (cdr list) obj)))


(defun json-to-form (json)
  (cond
    ((listp json)
     (mapcar #'json-to-form json))
    ((and (hash-table-p json) (nth-value 1 (gethash "name" json)))
     (let ((sym-name (gethash "name" json))
           (sym-package (gethash "package" json)))
       (intern sym-name sym-package)))
    ((and (hash-table-p json) (nth-value 1 (gethash "tail" json)))
     (let* ((head-list (gethash "head" json))
            (tail-obj (gethash "tail" json))
            (head (json-to-form head-list)))
       (set-last-cdr head (json-to-form tail-obj))
       head))
    (t
     ; Numbers & strings
     json)))


(defun normalize-client-form (form)
  (cond
    ((client-emacs-rex-p form)
     (write-form (seq-client-to-swank form)))
    ((client-raw-msg-p form)
     (nth 1 (nth 1 form)))
    (t
     (write-form (remove-client-seq form)))))


(defun normalize-swank-form (form)
  (let ((msg-type (car form)))
    (if (eql msg-type :return)
      (seq-swank-to-client (form-to-json form))
      (list 0 (form-to-json form)))))


(defun msg-client-to-swank (msg return-type)
  (when (not (stringp msg))
    (setf msg (swank/backend:utf8-to-string msg)))

  (let* ((json (yason:parse msg))
         (form (json-to-form json))
         (form-str (normalize-client-form form))
         (form-bytes (swank/backend:string-to-utf8 form-str))
         (form-bytes-len (length form-bytes)))
    (ecase return-type
      (:octets
        (concatenate '(vector (unsigned-byte 8))
                     (swank/backend:string-to-utf8 (format nil "~6,'0x" form-bytes-len))
                     form-bytes))
      (:string
        (format nil "~6,'0x~a" form-bytes-len form-str)))))


(defun msg-swank-to-client (msg return-type)
  (when (not (stringp msg))
    (setf msg (swank/backend:utf8-to-string msg)))

  (let* ((form (parse-form msg))
         (json (normalize-swank-form form))
         (encoded (with-output-to-string (json-out)
                    (yason:encode json json-out)))
         (full-line (concatenate
                      'string encoded (format nil "~c~c" #\return #\linefeed))))
    (ecase return-type
      (:octets
        (swank/backend:string-to-utf8 full-line))
      (:string
        full-line))))


(defun parse-line (data read-buffer)
  (setf read-buffer
        (concatenate '(vector (unsigned-byte 8)) read-buffer data))
  (let ((lf-pos (position (char-code #\linefeed) read-buffer)))
    (loop
      when lf-pos
        collect (swank/backend:utf8-to-string (subseq read-buffer 0 (1+ lf-pos))) into lines
        and do
          (setf read-buffer (subseq read-buffer (1+ lf-pos)))
          (setf lf-pos
                (position (char-code #\linefeed) read-buffer :start 0))
      else
        return (values lines read-buffer))))


(defun parse-swank-msg-len (buffer)
  (parse-integer
    (swank/backend:utf8-to-string (subseq buffer 0 +swank-msg-len-size+))
    :radix 16))


(defun parse-swank-msg (data read-buffer)
  (setf read-buffer
        (concatenate '(vector (unsigned-byte 8)) read-buffer data))
  (let ((msg-total-len
          (when (>= (length read-buffer) +swank-msg-len-size+)
            (+ +swank-msg-len-size+
               (parse-swank-msg-len read-buffer)))))
    (loop
      when (and msg-total-len (>= (length read-buffer) msg-total-len))
        collect (swank/backend:utf8-to-string
                  (subseq read-buffer +swank-msg-len-size+ msg-total-len))
                into msgs
        and do
          (setf read-buffer (subseq read-buffer msg-total-len))
          (if (>= (length read-buffer) +swank-msg-len-size+)
            (setf msg-total-len
                  (+ +swank-msg-len-size+
                     (parse-swank-msg-len read-buffer)))
            (setf msg-total-len nil))
      else
        return (values msgs read-buffer))))
