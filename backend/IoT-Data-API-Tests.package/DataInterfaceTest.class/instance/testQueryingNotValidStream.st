tests
testQueryingNotValidStream

	| interface stream |

	interface := DataInterface workingWith: rootSystem.

	self
		should: [ stream := interface streamNamed: 'Temperature' ofChannelIdentifiedBy: '2' ]
		raise: ResourceNotFound.

	self
		should: [ stream := interface streamNamed: 'pH' ofChannelIdentifiedBy: self identifier asString ]
		raise: ResourceNotFound