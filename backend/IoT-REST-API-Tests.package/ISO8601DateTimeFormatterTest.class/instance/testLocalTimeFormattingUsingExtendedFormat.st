tests
testLocalTimeFormattingUsingExtendedFormat

	self
		assert: (ISO8601DateTimeFormatter usingExtendedFormat format: (September sixth , 2015) atNoon)
		equals: '2015-09-06T12:00:00' , TimeZones local offset asString
