((DB-response (car(postmodern:query (:select :* :from (:checkCookie old-cookie IP)))))
(new-cookie (car DB-response))
(valid-till (cadr DB-response)))
(unless (= 0 new-cookie)

(unless(= new-cookie old-cookie)
  (set-cookie "chat" :value (intToChar new-cookie) :expires valid-till :path "/")

(multiple-value-bind (path theVisitor) (new-chat IP msg old-cookie type); "GgXj", #<VISITOR {10077B71C3}>
  (push (cons "path" path) json-response)
  (renew-cookie old-cookie new-cookie valid-till)))

(setf chat-status *chat-status*)
	      (when-let (mq) (when theVisitor (msg-queue theVisitor))
			(push (cons "messages" mq) json-response))
	      (setf success t))))))
