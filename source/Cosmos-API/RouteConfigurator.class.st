Class {
	#name : #RouteConfigurator,
	#superclass : #Object,
	#instVars : [
		'teapot',
		'webService',
		'routesAllowingCors'
	],
	#category : #'Cosmos-API-Model'
}

{ #category : #'instance creation' }
RouteConfigurator class >> on: aTeapot sendingMessagesTo: aWebService [

	^ self new initializeOn: aTeapot sendingMessagesTo: aWebService
]

{ #category : #configuring }
RouteConfigurator >> configure: aRouteSpecification [

	aRouteSpecification accept: self

]

{ #category : #'private - configuring' }
RouteConfigurator >> configureAsCorsAwareRoute: aCorsAwareRouteDecorator [

	| decoratee |

	decoratee := aCorsAwareRouteDecorator decoratee.

	routesAllowingCors
		at: decoratee resourceLocation
		ifPresent: [ :methods | methods add: decoratee httpMethod ]
		ifAbsentPut: (OrderedCollection with: decoratee httpMethod).

	decoratee accept: self
]

{ #category : #initialization }
RouteConfigurator >> initializeOn: aTeapot sendingMessagesTo: aWebService [ 
	
	teapot := aTeapot .
	webService := aWebService 
]
