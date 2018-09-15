Class {
	#name : #RouteConfigurator,
	#superclass : #Object,
	#instVars : [
		'teapot',
		'webService'
	],
	#category : #'Cosmos-API-Model'
}

{ #category : #'instance creation' }
RouteConfigurator class >> on: aTeapot sendingMessagesTo: aWebService [

	^ self new initializeOn: aTeapot sendingMessagesTo: aWebService
]

{ #category : #initialization }
RouteConfigurator >> initializeOn: aTeapot sendingMessagesTo: aWebService [ 
	
	teapot := aTeapot .
	webService := aWebService 
]
