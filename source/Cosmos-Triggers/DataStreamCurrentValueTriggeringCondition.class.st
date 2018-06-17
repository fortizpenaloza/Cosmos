Class {
	#name : #DataStreamCurrentValueTriggeringCondition,
	#superclass : #TriggeringCondition,
	#instVars : [
		'dataStream',
		'condition'
	],
	#category : #'Cosmos-Triggers-Model'
}

{ #category : #'instance creation' }
DataStreamCurrentValueTriggeringCondition class >> of: aDataStream comparingWith: aCondition [

	^ self new initializeOf: aDataStream comparingWith: aCondition
]

{ #category : #'instance creation' }
DataStreamCurrentValueTriggeringCondition class >> of: aDataStream isGreaterThan: aValue [

	^ self
		of: aDataStream
		comparingWith: (ArithmeticCondition toBeGreaterThan: aValue)
]

{ #category : #'instance creation' }
DataStreamCurrentValueTriggeringCondition class >> of: aDataStream isLessThan: aValue [

	^ self
		of: aDataStream
		comparingWith: (ArithmeticCondition toBeLessThan: aValue)
]

{ #category : #'initialize-release' }
DataStreamCurrentValueTriggeringCondition >> initializeOf: aDataStream comparingWith: aCondition [

	dataStream := aDataStream.
	condition := aCondition
]

{ #category : #testing }
DataStreamCurrentValueTriggeringCondition >> isSatisfiedOn: aContext [

	^ condition isSatisfiedBy: dataStream currentValue
]
