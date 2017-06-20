tests
testQueryingStreamAnswersItsNameAndLastRegisteredValuesAndLastDataPoints

	| interface stream |

	interface := DataInterface workingWith: rootSystem.
	stream := interface
		streamNamed: 'Temperature'
		ofChannelIdentifiedBy: self startingIdentifier asString.
	self assert: stream equals: self queryingStreamCalledTemperatureBelongingToChannelNumber1Answer 