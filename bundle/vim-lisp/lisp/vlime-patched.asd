;; vim: filetype=lisp
(asdf:defsystem #:vlime-patched
  :description "Asynchronous Vim <-> Swank interface (patched Swank)"
  :author "Kay Z. <l04m33@gmail.com>"
  :license "MIT"
  :version "0.4.0"
  :depends-on (#:vlime)
  :components ((:module "src"
                :pathname "src"
                :components ((:file "vlime-patched"))))
  :in-order-to ((test-op (test-op #:vlime-test))))
