tests
testQueryingStreamAnswersItsNameAndLastRegisteredValuesAndLastdataPoins

	| interface stream |

	interface := DataInterface workingWith: rootSystem.
	stream := interface
		streamNamed: 'Temperature'
		ofChannelIdentifiedBy: self identifier asString.
	self assert: stream equals: 
'{
	"name" : "Temperature",
	"currentValue" : 16,
	"lastUpdate" : "September 6, 2015 12:00:00 {(GMT-03:00) Local Time}",
	"data points" : [
		{
			"timestamp" : "September 6, 2015 12:00:00 {(GMT-03:00) Local Time}",
			"value" : 16
		}
	]
}'