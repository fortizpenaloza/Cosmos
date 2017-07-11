running
queryingChannelNumber1Answer
	
	| localTimeString |
	
	localTimeString := TimeZones local asString.
		
	^'{
	"name" : "Sensors #1",
	"data-streams" : [
		{
			"name" : "Temperature",
			"current-value" : 16,
			"last-update" : "September 6, 2015 12:00:00 {',localTimeString,'}"
		},
		{
			"name" : "Pressure",
			"current-value" : 1016,
			"last-update" : "September 6, 2015 12:00:00 {',localTimeString,'}"
		},
		{
			"name" : "Humidity",
			"current-value" : 72,
			"last-update" : "September 6, 2015 12:00:00 {',localTimeString,'}"
		}
	]
}'