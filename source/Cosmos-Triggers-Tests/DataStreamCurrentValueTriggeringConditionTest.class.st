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
		of: (DataStream named: 'Test' createdOn: self decemberTenthOf2016AtNoon)
		isLessThan: 10.

	self
		should: [ (condition isSatisfiedOn: self) ]
		raise: BindingNotYetDefined 
		withDescription: 'Current value has not been initialized.'
]
