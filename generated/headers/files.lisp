(defpackage :web-server/files
  (:nicknames "WS/files")
  (:use :cl :hunchentoot)
  (:shadow :start :stop :restart)
  (:export :start :stop :dispatchers))
(in-package :web-server/files)
