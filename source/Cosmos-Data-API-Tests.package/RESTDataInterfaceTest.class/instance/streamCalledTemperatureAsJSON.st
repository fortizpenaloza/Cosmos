accessing
streamCalledTemperatureAsJSON

	| localTimeString |

	localTimeString := TimeZones local asString.

	^ '{
	"name" : "Temperature",
	"current-value" : 16,
	"last-update" : "September 6, 2015 12:00:00 {' , localTimeString
		,
			'}",
	"data-points" : [
		{
			"timestamp" : "September 6, 2015 12:00:00 {' , localTimeString
		,
			'}",
			"value" : 16
		}
	]
}'