Class {
	#name : #CrossOriginResourceSharingHandler,
	#superclass : #Object,
	#instVars : [
		'httpMethods'
	],
	#category : #'Cosmos-API-Model'
}

{ #category : #'instance creation' }
CrossOriginResourceSharingHandler class >> allowing: anHttpMethodsCollection [

	^ self new initializeAllowing: anHttpMethodsCollection
]

{ #category : #initializaiton }
CrossOriginResourceSharingHandler >> initializeAllowing: anHttpMethodsCollection [

	httpMethods := anHttpMethodsCollection
]
