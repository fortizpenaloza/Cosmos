tests
testQueryingNotValidStream

	| interface stream |

	interface := RESTDataInterface workingWith: rootSystem.

	self
		should: [ stream := interface
				streamNamed: 'Temperature'
				ofChannelIdentifiedBy: '2' ]
		raise: HTTPClientError.

	self
		should: [ stream := interface
				streamNamed: 'pH'
				ofChannelIdentifiedBy: self startingIdentifier asString ]
		raise: HTTPClientError