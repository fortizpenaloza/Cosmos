tests
testQueryingNotValidStream

	| interface stream |

	interface := RESTDataInterface workingWith: rootSystem.

	self
		should:
			[ stream := interface streamNamed: 'pH' ]
		raise: HTTPClientError