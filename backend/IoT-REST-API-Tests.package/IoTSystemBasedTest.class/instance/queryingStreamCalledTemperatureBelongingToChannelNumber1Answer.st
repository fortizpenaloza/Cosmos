test - expectedResults
queryingStreamCalledTemperatureBelongingToChannelNumber1Answer
	
	| localTimeString |
	
	localTimeString := TimeZones local asString.
	
	^'{
	"name" : "Temperature",
	"currentValue" : 16,
	"lastUpdate" : "September 6, 2015 12:00:00 {',localTimeString,'}",
	"data points" : [
		{
			"timestamp" : "September 6, 2015 12:00:00 {',localTimeString,'}",
			"value" : 16
		}
	]
}'