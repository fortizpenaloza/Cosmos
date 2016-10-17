as yet unclassified
testUTCFormattingUsingExtendedFormat

	self
		assert:
			(ISO8601DateTimeFormatter usingExtendedFormat
				format: ((September sixth , 2015) atNoon convertTo: TimeZones universalTime))
		equals: '2015-09-06T15:00:00Z'