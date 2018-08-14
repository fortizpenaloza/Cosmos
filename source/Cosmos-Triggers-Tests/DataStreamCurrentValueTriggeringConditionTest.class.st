"
An DataStreamCurrentValueTriggerConditionTest  is a test class for testing the behavior of DataStreamCurrentValueTriggerConditionTest
"
Class {
	#name : #DataStreamCurrentValueTriggeringConditionTest,
	#superclass : #TestCase,
	#instVars : [
		'currentValue'
	],
	#category : 'Cosmos-Triggers-Tests-Model'
}

{ #category : #history }
DataStreamCurrentValueTriggeringConditionTest class >> lastStoredRun [
	^ ((Dictionary new) add: (#timeStamp->(DateAndTime basicNew instVarAt: 1 put: 6510; instVarAt: 2 put: (Duration seconds: -10800 nanoSeconds: 0); instVarAt: 3 put: 2458339; instVarAt: 4 put: 624450000; yourself)); add: (#passed->((Set new) add: #testIsSafisfied; add: #testIsSafisfiedWhenDataStreamCurrentValueHasntBeenInitialized; yourself)); add: (#failures->((Set new))); add: (#errors->((Set new))); yourself)
]

{ #category : #accessing }
DataStreamCurrentValueTriggeringConditionTest >> currentValue [

	^ currentValue
]

{ #category : #accessing }
DataStreamCurrentValueTriggeringConditionTest >> decemberTenthOf2016AtNoon [

	^ (December tenth , 2016) atNoon
]

{ #category : #tests }
DataStreamCurrentValueTriggeringConditionTest >> testIsSafisfied [

	| condition |

	condition := DataStreamCurrentValueTriggeringCondition of: self isLessThan: 10.
	
	currentValue := 9.99.
	self assert: (condition isSatisfiedOn: self).
	
	currentValue := 10.
	self deny: (condition isSatisfiedOn: self).
	
	currentValue := 10.1.
	self deny: (condition isSatisfiedOn: self)
]

{ #category : #tests }
DataStreamCurrentValueTriggeringConditionTest >> testIsSafisfiedWhenDataStreamCurrentValueHasntBeenInitialized [

	| condition |

	condition := DataStreamCurrentValueTriggeringCondition
		of: (DataStream named: 'Test')
		isLessThan: 10.

	self
		should: [ condition isSatisfiedOn: self ]
		raise: DataStreamIsEmpty
		withDescription: 'Current value has not been initialized'
]
