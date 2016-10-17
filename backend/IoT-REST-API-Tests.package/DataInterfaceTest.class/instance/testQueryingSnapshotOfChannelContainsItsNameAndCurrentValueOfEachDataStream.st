tests
testQueryingSnapshotOfChannelContainsItsNameAndCurrentValueOfEachDataStream

	| interface response |
	interface :=	DataInterface workingWith: rootSystem.
	response := interface currentSnapshotOfChannelIdentifiedBy: self identifier asString.
	
	self assert: response equals: 
'{
	"name" : "Sensors #1",
	"dataStreams" : [
		{
			"name" : "Temperature",
			"currentValue" : 16,
			"lastUpdate" : "September 6, 2015 12:00:00 {(GMT-03:00) Local Time}"
		},
		{
			"name" : "Pressure",
			"currentValue" : 1016,
			"lastUpdate" : "September 6, 2015 12:00:00 {(GMT-03:00) Local Time}"
		},
		{
			"name" : "Humidity",
			"currentValue" : 72,
			"lastUpdate" : "September 6, 2015 12:00:00 {(GMT-03:00) Local Time}"
		}
	]
}'