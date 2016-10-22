test - expectedResults
queryingChannelNumber1Answer
	
	| localTimeString |
	
	localTimeString := TimeZones local asString.
		
	^'{
	"name" : "Sensors #1",
	"dataStreams" : [
		{
			"name" : "Temperature",
			"currentValue" : 16,
			"lastUpdate" : "September 6, 2015 12:00:00 {',localTimeString,'}"
		},
		{
			"name" : "Pressure",
			"currentValue" : 1016,
			"lastUpdate" : "September 6, 2015 12:00:00 {',localTimeString,'}"
		},
		{
			"name" : "Humidity",
			"currentValue" : 72,
			"lastUpdate" : "September 6, 2015 12:00:00 {',localTimeString,'}"
		}
	]
}'