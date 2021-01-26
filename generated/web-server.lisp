(defun log-WS (log-type &rest message)
  (apply #'SL:log 
    (cons log-type (cons (concatenate 'string "WS " (car message)) (cdr message)))))

(defmethod acceptor-log-message ((acc tbnl:acceptor) log-type format-string &rest format-arguments)
"log function for Hunchentoot"
(let((LT(case log-type
	  (:error sl:error)
	  (:info sl:info)
	  (:warning sl:warning)
	  (otherwise sl:debug))))
  (apply #'SL:log (cons LT (cons (concatenate 'string "WS " format-string) format-arguments)))))

(defvar *dispatchers* '())
(defclass vhost (tbnl:acceptor)
()
(:default-initargs
  :address "127.0.0.1"
  :document-root #p"/srv/www/chalaev.com/"
  :error-template-directory #p"/srv/www/chalaev.com/errors/"))

(defmethod dispatch-table((acceptor vhost))
  (append *dispatchers* (web-server/files:dispatchers)))

(defmethod tbnl:acceptor-dispatch-request ((vhost vhost) request); called by (default)  HANDLE-REQUEST(acceptor) method.

(mapc #'(lambda(dispatcher); asking every dispatcher for a hndler until one of them provides it
	    (when-let((handler(funcall dispatcher request))); Great! We've got a handler, so
	      (return-from tbnl:acceptor-dispatch-request (funcall handler)))); let's lauch it
	(dispatch-table vhost))
(log-WS sl:debug "none of my dispatchers matched")
  (call-next-method))

(defmethod tbnl:acceptor-status-message ((acceptor vhost) http-status-code &rest properties &key &allow-other-keys)
  "Provides custom web pages on errors."
  (labels ((file-contents(file-stream)
         (let ((buf (make-string (file-length file-stream))))
           (read-sequence buf file-stream)
           buf)))
(if(= 200 http-status-code) (call-next-method); otherwise we have error
(let((FN (make-pathname
                   :name (princ-to-string http-status-code)
                   :type "html"
                   :defaults (tbnl:acceptor-error-template-directory acceptor))))
(ifn(probe-file FN) (call-next-method)
(setf (tbnl:content-type*) "text/html")
(with-open-file (file-stream FN :if-does-not-exist nil :element-type 'character)
  (file-contents file-stream)))))))

(defvar virtual-host nil)
(defvar stop-the-server (bt:make-condition-variable))
(defun stop()
  (tbnl:stop virtual-host)
  (bt:condition-notify stop-the-server))
(defun start(&optional interactive)
(setf virtual-host (make-instance 'vhost :port 50001))
(unless *dispatchers*
  (push (tbnl:create-regex-dispatcher "^/status$" 'status) *dispatchers*))
  (web-server/files:start)
  (tbnl:start virtual-host)
  (swank:create-server)

(unless interactive
(let((SL-lock (bt:make-lock)))
  (bt:with-lock-held(SL-lock)
     (sb-thread:condition-wait stop-the-server SL-lock)))))

(defun status() "this web page is gonna show lots of useful information")
