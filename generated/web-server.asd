(asdf:defsystem "web-server"
  :class :package-inferred-system
  :description "template web server"
;;  :long-description #.(uiop:read-file-string (uiop/pathname:subpathname *load-pathname* "description.org"))
  :author "Oleg Shalaev"
  :mailto "oleg@chalaev.com"
  :licence "MIT"
  :version (:read-file-line "version.org")
  :depends-on (:shalaev :hunchentoot :simple-log  :web-server/files :swank)
;;  :in-order-to ((test-op (test-op "web-server/tests")))
  :serial t
  :components ((:file "web-server")) ; (:file "html")  for better html + css
  :build-operation  "program-op"
  :build-pathname "binary"
  :entry-point "web-server:start")
#+sb-core-compression
(defmethod asdf:perform ((o asdf:image-op) (c asdf:system))
  (uiop:dump-image (asdf:output-file o c) :executable t :compression t))

(asdf:defsystem "web-server/files"
    :class :package-inferred-system
    :depends-on (:hunchentoot :simple-log :cl-fad)
    :description "Simple web page serving static files"
    :author "Oleg Shalaev"
    :mailto "oleg@chalaev.com"
    :licence "MIT"
    :components ((:file "files")))
