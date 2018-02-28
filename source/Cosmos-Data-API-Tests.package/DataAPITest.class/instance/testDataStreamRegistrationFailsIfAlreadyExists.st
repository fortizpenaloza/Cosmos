tests
testDataStreamRegistrationFailsIfAlreadyExists

	| interface |

	interface := DataAPI workingWith: rootSystem.

	self
		should: [ interface registerStreamFrom: '{"name": "Temperature"}' ]
		raise: HTTPClientError
		withDescription: 'A data stream with that name already exists in system'