(defun log-WSF (log-type &rest message)
  (apply #'SL:log 
    (cons log-type (cons (concatenate 'string "WSF " (car message)) (cdr message)))))

(defun folder-dispatcher(uri-prefix base-path &optional guard realm content-type callback)
;; e.g., → (folder-dispatcher "/"      "/srv/www/chalaev.com/")
  "serves static files when guard"
(create-prefix-dispatcher uri-prefix
  #'(lambda()
(log-message* :debug "my dispatcher worked")
(let((req-path(request-pathname *request* uri-prefix)))
(when (null req-path) (setf (return-code*) +http-forbidden+) (abort-req-handler))
(when(or(null guard)
(multiple-value-bind(uName pass) (authorization *request*)
(if(funcall guard uName pass req-path) t
   (if realm(require-authorization realm)(require-authorization)))))

(handle-static-file (merge-pathnames req-path base-path)
                     content-type callback))))))

(defvar *dispatchers* '());  "local dispatchers"
(defun dispatchers() *dispatchers*)
(defun my-guard(user-name pass &optional path)
"checks user name and password; might be path-dependent"
  (and user-name pass (string= user-name "oleg") (string= pass (format nil "shalaev~d" (nth-value 2 (decode-universal-time (get-universal-time)))))))

(defun start()
;;  (push (create-folder-dispatcher-and-handler "/pub/" "/srv/www/chalaev.com/pub/") *dispatchers*) ; ←  standard (also works)
  (push (folder-dispatcher "/"      "/srv/www/chalaev.com/") *dispatchers*); unprotected because no login/password checker supplied
  (push (folder-dispatcher "/test/" "/srv/www/chalaev.com/test/" #'my-guard "Oleg's website") *dispatchers*)); ← basic authentication
(defun stop()
  (log-WSF SL:info "removing ~d dispatchers in :web-server/files" (length *dispatchers*))
  (setf *dispatchers* nil))
(defun restart()
(stop) (start))
