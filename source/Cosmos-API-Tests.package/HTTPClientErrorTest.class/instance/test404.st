tests-accessing
test404

	self
		should: [ HTTPClientError signalNotFound ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal code equals: 404;
				assert: signal messageText equals: 'Not found' ]