;;;; with-setf.asd

(asdf:defsystem #:with-setf
  :description "Macros for setting a place for the duration of a scope"
  :author "Chris Bagley (Baggers) <techsnuffle@gmail.com>"
  :license "Unlicense"
  :serial t
  :components ((:file "package")
               (:file "with-setf")))
