Class {
	#name : #DataAPIContext,
	#superclass : #Object,
	#instVars : [
		'rootSystem'
	],
	#category : #'Cosmos-Data-API-Core'
}

{ #category : #'instance creation' }
DataAPIContext class >> workingWith: aCompositeSytem [

	^ self new initializeWorkingWith: aCompositeSytem 

	
]

{ #category : #initialization }
DataAPIContext >> initializeWorkingWith: aCompositeSystem [ 

	rootSystem := aCompositeSystem 
]
