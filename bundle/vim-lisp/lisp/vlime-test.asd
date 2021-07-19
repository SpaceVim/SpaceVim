;; vim: filetype=lisp
(asdf:defsystem #:vlime-test
  :description "Tests for vlime"
  :author "Kay Z. <l04m33@gmail.com>"
  :license "MIT"
  :version "0.4.0"
  :depends-on (#:vlime
               #:prove
               #+sbcl #:sb-cover)
  :defsystem-depends-on (#:prove-asdf)
  :components ((:module "test"
                :pathname "test"
                :components (#+sbcl (:file "test-with-coverage")
                             (:test-file "vlime-protocol-test"))))
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run) :prove) c)))
