expected results
triggersAsJSON

	^ '[
	{
		"name" : "Always set triggered to true",
		"created_on" : "2015-09-06T12:00:00-03:00",
		"policy" : {
			"type" : "periodical",
			"time_interval" : "5 minutes"
		},
		"action" : "Set triggered to true",
		"condition" : "true"
	}
]'