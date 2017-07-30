tests-accessing
test409

	self
		should: [ HTTPClientError signalConflict: 'Sigmund Freud' ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal code equals: 409;
				assert: signal messageText equals: 'Sigmund Freud' ]