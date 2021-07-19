(in-package #:cl-user)

(defpackage #:test-with-coverage
  (:use #:cl #:asdf #:sb-cover)
  (:export #:main))

(in-package #:test-with-coverage)


(defun main (test-systems coverage-report-dir)
  (let ((dep-systems
          (loop for sys in test-systems
                append (remove-if
                         #'(lambda (s) (member s test-systems))
                         (system-depends-on (find-system sys))))))
    (declaim (optimize (store-coverage-data 0)))  
    (dolist (sys dep-systems)
      (compile-system sys)))
  
  (declaim (optimize store-coverage-data))
  (dolist (sys test-systems)
    (compile-system sys :force t))

  (declaim (optimize (store-coverage-data 0)))
  (dolist (sys test-systems)
    (test-system sys))
  
  (ensure-directories-exist coverage-report-dir)
  (report coverage-report-dir))
