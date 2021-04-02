(in-package #:cl-user)

(defpackage #:vlime-protocol-test
  (:use #:cl
        #:prove
        #:yason
        #:vlime-protocol))

(in-package #:vlime-protocol-test)


(plan 28)

(ok
  (equal (parse-form "(simple form)")
         '(swank-io-package::simple swank-io-package::form))
  "parse-form - simple form")

(ok
  (equal (parse-form "(vlime-protocol-test::qualified vlime-protocol-test::form)")
         '(qualified form))
  "parse-form - qualified symbols")

(ok
  (equal (write-form '(simple form))
         "(vlime-protocol-test::simple vlime-protocol-test::form)")
  "write-form - simple form")

(ok
  (equal (write-form '(vlime-protocol-test::qualified vlime-protocol-test::form))
         "(vlime-protocol-test::qualified vlime-protocol-test::form)")
  "write-form - qualified symbols")

(let ((json (form-to-json '(simple form))))
  (ok (listp json)
      "form-to-json - simple form to json list")
  (ok (equal (gethash "name" (nth 0 json)) "SIMPLE")
      "form-to-json - simple form symbol name 1")
  (ok (equal (gethash "name" (nth 1 json)) "FORM")
      "form-to-json - simple form symbol name 2")
  (ok (equal (gethash "package" (nth 0 json)) "VLIME-PROTOCOL-TEST")
      "form-to-json - simple form package name 1")
  (ok (equal (gethash "package" (nth 1 json)) "VLIME-PROTOCOL-TEST")
      "form-to-json - simple form package name 2"))

(ok (eql (form-to-json 42) 42)
    "form-to-json - number")

(ok (equal (form-to-json "dummy string") "dummy string")
    "form-to-json - string")

(ok (eql (form-to-json t) t)
    "form-to-json - t")

(ok (eql (form-to-json nil) nil)
    "form-to-json - nil")

(let ((json (form-to-json '(a b . 42))))
  (ok (hash-table-p json)
      "form-to-json - cons cell")
  (ok (listp (gethash "head" json))
      "form-to-json - cons cell head list")
  (ok (equal (gethash "name" (nth 0 (gethash "head" json))) "A")
      "form-to-json - cons cell head symbol 1")
  (ok (equal (gethash "name" (nth 1 (gethash "head" json))) "B")
      "form-to-json - cons cell head symbol 2")
  (ok (eql (gethash "tail" json) 42)
      "form-to-json - cons cell tail"))

(let ((json-sym-1 (parse "{\"name\":\"SIMPLE\", \"package\":\"VLIME-PROTOCOL-TEST\"}"))
      (json-sym-2 (parse "{\"name\":\"FORM\", \"package\":\"VLIME-PROTOCOL-TEST\"}"))
      (json-cons (parse "{\"head\":[{\"name\":\"SIMPLE\", \"package\":\"VLIME-PROTOCOL-TEST\"}],
                          \"tail\":{\"name\":\"FORM\", \"package\":\"VLIME-PROTOCOL-TEST\"}}")))
  (ok
    (equal (json-to-form (list json-sym-1 json-sym-2))
           '(simple form))
    "json-to-form - simple form")

  (ok
    (equal (json-to-form json-cons)
           '(simple . form))
    "json-to-form - cons cell"))

(ok
  (eql (json-to-form 42) 42)
  "json-to-form - number")

(ok
  (equal (json-to-form "dummy string") "dummy string")
  "json-to-form - string")

(ok
  (eql (json-to-form t) t)
  "json-to-form - t")

(ok
  (eql (json-to-form nil) nil)
  "json-to-form - nil")

(ok
  (equal (msg-client-to-swank "[1, [{\"name\":\"EMACS-REX\", \"package\":\"KEYWORD\"},
                                    [{\"name\":\"CONNECTION-INFO\", \"package\":\"SWANK\"}],
                                    null, true]]"
                              :string)
         "00002C(:emacs-rex (swank:connection-info) nil t 1)")
  "msg-client-to-swank - simple message")

(ok
  (equal (msg-client-to-swank "[1, [{\"name\":\"VLIME-RAW-MSG\", \"package\":\"KEYWORD\"},
                                    \"This-is-a-raw-message\"]]"
                              :string)
         "000015This-is-a-raw-message")
  "msg-client-to-swank - raw message")

(let ((msg (msg-swank-to-client "(:return (:ok 42) 1)" :string))
      (cr-lf (format nil "~c~c" #\return #\linefeed)))
  (ok
    (or
      (equal (subseq msg 0 (- (length msg) 2))
             "[1,[{\"name\":\"RETURN\",\"package\":\"KEYWORD\"},[{\"name\":\"OK\",\"package\":\"KEYWORD\"},42]]]")
      (equal (subseq msg 0 (- (length msg) 2))
             "[1,[{\"package\":\"KEYWORD\",\"name\":\"RETURN\"},[{\"name\":\"OK\",\"package\":\"KEYWORD\"},42]]]")
      (equal (subseq msg 0 (- (length msg) 2))
             "[1,[{\"name\":\"RETURN\",\"package\":\"KEYWORD\"},[{\"package\":\"KEYWORD\",\"name\":\"OK\"},42]]]")
      (equal (subseq msg 0 (- (length msg) 2))
             "[1,[{\"package\":\"KEYWORD\",\"name\":\"RETURN\"},[{\"package\":\"KEYWORD\",\"name\":\"OK\"},42]]]"))
    "msg-swank-to-client - simple message")
  
  (ok
    (equal (subseq msg (- (length msg) 2)) cr-lf)
    "msg-swank-to-client - cr-lf"))

(finalize)
