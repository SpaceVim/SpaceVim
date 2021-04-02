(in-package #:cl-user)

(defpackage #:vlime
  (:use #:cl)
  (:export #:main
           #:try-to-load))

(in-package #:vlime)


(defgeneric start-server (backend host port swank-host swank-port dont-close))


(define-condition quicklisp-not-found-error (error)
  ((package :initarg :package
            :initform nil
            :reader dep-install-error-package))
  (:report
    (lambda (c s)
      (format
        s
        "Quicklisp not found. Please set up Quicklisp or install the dependencies for ~a manually.~%"
        (dep-install-error-package c)))))


(defun dyn-call (package sym &rest args)
  (apply (symbol-function (find-symbol sym package)) args))

(defun install-with-quicklisp (package)
  (when (not (find-package "QUICKLISP-CLIENT"))
    (error (make-condition 'quicklisp-not-found-error :package package)))
  (dyn-call "QUICKLISP-CLIENT" "QUICKLOAD" package))

(defun try-to-load (package)
  (handler-case
    (asdf:load-system package)
    (asdf:missing-dependency ()
      (install-with-quicklisp package))))

(defun main (&key backend
                  (interface #(127 0 0 1))
                  (port 0)
                  port-file
                  (start-swank t)
                  (swank-interface #(127 0 0 1) swank-interface-p)
                  (swank-port 0 swank-port-p)
                  (dont-close t))
  (when (not backend)
    (let ((preferred-style (dyn-call "SWANK/BACKEND" "PREFERRED-COMMUNICATION-STYLE")))
      (case preferred-style
        (:spawn
          (setf backend :vlime-usocket))
        (:fd-handler
          (setf backend :vlime-sbcl))
        ((nil)
         (setf backend :vlime-patched))
        (t
          (format *error-output*
                  "Vlime: Communication style ~s not supported.~%" preferred-style)
          (return-from main)))))

  (let ((swank-comm-style
          (dyn-call "SWANK/BACKEND" "PREFERRED-COMMUNICATION-STYLE")))
    (labels ((announce-swank-port (port)
               (setf swank-port port))
             (announce-vlime-port (port)
               (when port-file
                 (with-open-file (pf port-file
                                  :direction :output
                                  :if-exists :supersede
                                  :if-does-not-exist :create)
                   (with-standard-io-syntax
                     (write port :stream pf)))))
             (start-vlime-server (backend)
               (let ((to-connect
                       ; When connecting, use #(127 0 0 1) instead of #(0 0 0 0)
                       (if (> (loop for b across swank-interface sum b) 0)
                         swank-interface
                         #(127 0 0 1))))
                 (multiple-value-bind (server local-name)
                                      (start-server backend
                                                    interface port
                                                    to-connect swank-port
                                                    dont-close)
                   (declare (ignore server))
                   (announce-vlime-port (nth 1 local-name)))))
             (start-swank-server (announce-port)
               (let ((swank-loopback (symbol-value (find-symbol "*LOOPBACK-INTERFACE*" "SWANK"))))
                 ; This is... ugly and not safe at all, but we don't have access
                 ; to the SWANK package when bootstrapping.
                 (unwind-protect
                   (progn
                     (setf (symbol-value (find-symbol "*LOOPBACK-INTERFACE*" "SWANK"))
                           (format nil "~{~a~^.~}"
                                   (loop for b across swank-interface collect b)))
                     (dyn-call "SWANK" "SETUP-SERVER"
                               swank-port announce-port swank-comm-style dont-close nil))
                   (setf (symbol-value (find-symbol "*LOOPBACK-INTERFACE*" "SWANK")) swank-loopback)))))
      (ecase backend
        (:vlime-usocket
          (try-to-load :vlime-usocket)
          (when start-swank
            (start-swank-server #'announce-swank-port))
          (start-vlime-server :usocket))
        (:vlime-sbcl
          (try-to-load :vlime-sbcl)
          (when start-swank
            (start-swank-server #'announce-swank-port))
          (start-vlime-server :sbcl))
        (:vlime-patched
          (try-to-load :vlime-patched)
          (dyn-call "VLIME-PATCHED" "PATCH-SWANK")
          ;; SWANK-INTERFACE and SWANK-PORT are ignored in this case.
          (when (or swank-interface-p swank-port-p)
            (warn "SWANK-INTERFACE and SWANK-PORT are ignored when using the VLIME-PATCHED backend."))
          (setf swank-interface interface
                swank-port port)
          (start-swank-server
            #'(lambda (port)
                (format t "Server created: (~a ~a)~%" swank-interface port)
                (announce-vlime-port port))))))))
