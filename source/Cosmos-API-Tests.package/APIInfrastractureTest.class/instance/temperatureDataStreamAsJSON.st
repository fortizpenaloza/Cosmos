expected results
temperatureDataStreamAsJSON

	^ '{
	"name" : "Temperature",
	"current-value" : 16,
	"last-update" : "2015-09-06T12:00:00<1p>",
	"data-points" : [
		{
			"timestamp" : "2015-09-06T12:00:00<1p>",
			"value" : 16
		},
		{
			"timestamp" : "2015-09-06T12:00:00<1p>",
			"value" : 15.5
		}
	]
}' expandMacrosWith: TimeZones local offset