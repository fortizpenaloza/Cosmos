tests-accessing
testCode

	self
		should: [ HTTPClientError signal: 404 describedBy: 'Not Found' ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal code equals: 404;
				assert: signal messageText equals: 'Not Found' ]