Class {
	#name : #ISO8601DateFormatterTest,
	#superclass : #TestCase,
	#category : 'Cosmos-API-Tests-Formatting'
}

{ #category : #history }
ISO8601DateFormatterTest class >> lastStoredRun [
	^ ((Dictionary new) add: (#timeStamp->(DateAndTime basicNew instVarAt: 1 put: 6510; instVarAt: 2 put: (Duration seconds: -10800 nanoSeconds: 0); instVarAt: 3 put: 2458339; instVarAt: 4 put: 645232000; yourself)); add: (#passed->((Set new) add: #testFormattingUsingExtendedFormat; add: #testFormattingUsingBasicFormat; yourself)); add: (#failures->((Set new))); add: (#errors->((Set new))); yourself)
]

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
