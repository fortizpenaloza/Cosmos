expected results
dataStreamsSnapshotAsJSON

	^ '[
	{
		"name" : "Temperature",
		"current-value" : 16,
		"last-update" : "2015-09-06T12:00:00<1p>"
	},
	{
		"name" : "Pressure",
		"current-value" : 1016,
		"last-update" : "2015-09-06T12:00:00<1p>"
	},
	{
		"name" : "Humidity",
		"current-value" : 72,
		"last-update" : "2015-09-06T12:00:00<1p>"
	}
]' expandMacrosWith: TimeZones local offset