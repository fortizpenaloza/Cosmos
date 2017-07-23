tests
testFormattingUsingBasicFormat

	self
		assert: (ISO8601DateFormatter usingBasicFormat format: September sixth , 1979)
		equals: '19790906'.

	self
		assert: (ISO8601DateFormatter usingBasicFormat format: October first , 2014)
		equals: '20141001'