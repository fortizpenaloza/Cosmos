"
I'm a DataPoint.

A data point represents a single value of a data stream at a specific point in time. It is simply a key value pair consisting of a timestamp and the value at that time.

"
Class {
	#name : #DataPoint,
	#superclass : #Object,
	#instVars : [
		'timestamp',
		'value'
	],
	#category : 'Cosmos-Data-Core-Model'
}

{ #category : #'instance creation' }
DataPoint class >> on: aTimestamp holding: aValue [

	^ self new initializeOn: aTimestamp holding: aValue
]

{ #category : #'initialize-release' }
DataPoint >> initializeOn: aTimestamp holding: aValue [

	timestamp := aTimestamp.
	value := aValue
]

{ #category : #printing }
DataPoint >> printOn: aStream [ 	
	
	timestamp printOn: aStream.
	aStream nextPut: $-.
	value printOn: aStream
	
]

{ #category : #accessing }
DataPoint >> timestamp [

	^ timestamp
]

{ #category : #accessing }
DataPoint >> value [

	^ value
]
