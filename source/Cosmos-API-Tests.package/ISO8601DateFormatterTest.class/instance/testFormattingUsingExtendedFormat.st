tests
testFormattingUsingExtendedFormat

	self
		assert: (ISO8601DateFormatter usingExtendedFormat format: September sixth , 1979)
		equals: '1979-09-06'.

	self
		assert: (ISO8601DateFormatter usingExtendedFormat format: October first , 2014)
		equals: '2014-10-01'