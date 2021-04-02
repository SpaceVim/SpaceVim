(in-package #:cl-user)
(when (not (find-package "VLIME-LOADER"))
  (defpackage #:vlime-loader
    (:use #:cl)))
(in-package #:vlime-loader)


(require :asdf)

(defparameter *vlime-home*
  (make-pathname :directory (pathname-directory *load-truename*)
                 :device (pathname-device *load-truename*)
                 ;; Issue #27: :HOST is needed for Windows XP (?) to build the correct path.
                 :host (pathname-host *load-truename*)))

(defun dyn-call (package sym &rest args)
  (apply (symbol-function (find-symbol sym package)) args))

(defun load-vlime ()
  (let ((vlime-src (merge-pathnames (parse-namestring "src/vlime.lisp") *vlime-home*)))
    (load vlime-src)
    (asdf:initialize-source-registry
      `(:source-registry
         (:directory ,*vlime-home*)
         :inherit-configuration))
    (dyn-call "VLIME" "TRY-TO-LOAD" :vlime)
    t))

(load-vlime)
