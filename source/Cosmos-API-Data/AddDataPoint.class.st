Class {
	#name : #AddDataPoint,
	#superclass : #Object,
	#instVars : [
		'dataPoint',
		'dataStream'
	],
	#category : #'Cosmos-API-Data'
}

{ #category : #'instance creation' }
AddDataPoint class >> adding: aDataPoint toStreamNamed: aName on: aDataStreamSystem [

	| dataStream |

	dataStream := aDataStreamSystem streamNamed: aName.

	^ self new initializeAdding: aDataPoint to: dataStream
]

{ #category : #accessing }
AddDataPoint >> dataPoint [

	^ dataPoint
]

{ #category : #accessing }
AddDataPoint >> dataStream [

	^ dataStream
]

{ #category : #initialization }
AddDataPoint >> initializeAdding: aDataPoint to: aDataStream [

	dataPoint := aDataPoint. 
	dataStream := aDataStream
]
