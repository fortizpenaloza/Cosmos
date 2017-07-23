tests
testDataStreamRegistrationFailsIfAlreadyExists

	| interface |

	interface := RESTDataInterface workingWith: rootSystem.

	self should: [ interface registerStreamNamed: 'Temperature' ]
	raise: HTTPClientError 
	withDescription: 'A data stream with that name already exists in system'