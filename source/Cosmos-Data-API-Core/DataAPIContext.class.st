Class {
	#name : #DataAPIContext,
	#superclass : #Object,
	#instVars : [
		'cosmosSystem'
	],
	#category : #'Cosmos-Data-API-Core'
}

{ #category : #'instance creation' }
DataAPIContext class >> workingWith: aCosmosSystem [

	^ self new initializeWorkingWith: aCosmosSystem 

	
]

{ #category : #initialization }
DataAPIContext >> initializeWorkingWith: aCosmosSystem [ 

	cosmosSystem := aCosmosSystem 
]
