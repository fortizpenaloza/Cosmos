"
I'm metadata.

I'm being used to describe ortogonal aspects of any object.


"
Class {
	#name : #Metadata,
	#superclass : #Object,
	#instVars : [
		'value',
		'aspect',
		'describedObject'
	],
	#category : #'Cosmos-Metadata'
}

{ #category : #'instance creation' }
Metadata class >> about: anObject where: anAspect is: aValue [

	^ self new initializeAbout: anObject where: anAspect is: aValue
]

{ #category : #comparing }
Metadata >> = anObject [

	^ self == anObject
		or: [ self class = anObject class
				and: [ aspect = anObject aspect
						and: [ describedObject = anObject describedObject and: [ value = anObject value ] ] ] ]
]

{ #category : #accessing }
Metadata >> aspect [

	^ aspect
]

{ #category : #accessing }
Metadata >> describedObject [

	^ describedObject 
]

{ #category : #comparing }
Metadata >> hash [

	^ (aspect hash bitXor: describedObject hash) bitXor: value hash
]

{ #category : #initialization }
Metadata >> initializeAbout: anObject where: anAspect is: aValue [

	aspect := anAspect.
	describedObject := anObject.
	value := aValue
]

{ #category : #printing }
Metadata >> printOn: aStream [

	aspect printOn: aStream.
	aStream
		nextPutAll: ' of '.
	describedObject printOn: aStream.
	aStream
		nextPutAll: ' is '.
	value printOn: aStream
]

{ #category : #accessing }
Metadata >> value [ 

	^ value
]
