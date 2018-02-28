tests
testDataStreamRegistrationFailsWithMalformattedRequest

	| interface |

	interface := DataAPI workingWith: rootSystem.

	self
		should: [ interface registerStreamFrom: '{"xxx": "Temperature"}' ]
		raise: HTTPClientError
		withDescription: 'key #name not found in Dictionary'