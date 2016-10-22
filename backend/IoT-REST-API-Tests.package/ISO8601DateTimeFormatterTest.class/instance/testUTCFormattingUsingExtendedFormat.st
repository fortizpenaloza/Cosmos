as yet unclassified
testUTCFormattingUsingExtendedFormat

	self
		assert:
			(ISO8601DateTimeFormatter usingExtendedFormat
				format: self septemberSixthAtNoonUTC)
		equals: '2015-09-06T12:00:00Z'