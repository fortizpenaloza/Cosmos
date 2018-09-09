Class {
	#name : #ISO8601DateFormatterTest,
	#superclass : #TestCase,
	#category : 'Cosmos-API-Tests-Formatting'
}

{ #category : #tests }
ISO8601DateFormatterTest >> testFormattingUsingBasicFormat [

	self
		assert: (ISO8601DateFormatter usingBasicFormat format: September sixth , 1979)
		equals: '19790906'.

	self
		assert: (ISO8601DateFormatter usingBasicFormat format: October first , 2014)
		equals: '20141001'
]

{ #category : #tests }
ISO8601DateFormatterTest >> testFormattingUsingExtendedFormat [

	self
		assert: (ISO8601DateFormatter usingExtendedFormat format: September sixth , 1979)
		equals: '1979-09-06'.

	self
		assert: (ISO8601DateFormatter usingExtendedFormat format: October first , 2014)
		equals: '2014-10-01'
]
