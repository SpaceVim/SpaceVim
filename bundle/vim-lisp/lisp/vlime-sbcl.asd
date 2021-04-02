;; vim: filetype=lisp
(asdf:defsystem #:vlime-sbcl
  :description "Asynchronous Vim <-> Swank interface (SBCL backend)"
  :author "Kay Z. <l04m33@gmail.com>"
  :license "MIT"
  :version "0.4.0"
  :depends-on (#:vlime
               #:sb-bsd-sockets
               #:sb-introspect
               #:vom)
  :components ((:module "src"
                :pathname "src"
                :components ((:file "vlime-connection")
                             (:file "aio-sbcl")
                             (:file "vlime-sbcl"
                              :depends-on ("vlime-connection" "aio-sbcl")))))
  :in-order-to ((test-op (test-op #:vlime-sbcl-test))))
