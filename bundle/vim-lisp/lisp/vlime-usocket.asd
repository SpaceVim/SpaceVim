;; vim: filetype=lisp
(asdf:defsystem #:vlime-usocket
  :description "Asynchronous Vim <-> Swank interface (usocket backend)"
  :author "Kay Z. <l04m33@gmail.com>"
  :license "MIT"
  :version "0.4.0"
  :depends-on (#:vlime
               #:usocket
               #:vom)
  :components ((:module "src"
                :pathname "src"
                :components ((:file "vlime-usocket"))))
  :in-order-to ((test-op (test-op #:vlime-test))))
