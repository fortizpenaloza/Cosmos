tests
testQueryingStreamAnswersItsNameAndLastRegisteredValuesAndLastdataPoins

	| interface stream |

	interface := DataInterface workingWith: rootSystem.
	stream := interface
		streamNamed: 'Temperature'
		ofChannelIdentifiedBy: self identifier asString.
	self assert: stream equals: self queryingStreamCalledTemperatureBelongingToChannelNumber1Answer 