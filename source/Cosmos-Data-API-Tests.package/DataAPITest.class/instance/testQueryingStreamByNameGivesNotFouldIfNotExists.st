tests
testQueryingStreamByNameGivesNotFouldIfNotExists

	| interface stream |

	interface := DataAPI workingWith: rootSystem.

	self
		should:
			[ stream := interface streamNamed: 'pH' ]
		raise: HTTPClientError
		withDescription: 'Not found'