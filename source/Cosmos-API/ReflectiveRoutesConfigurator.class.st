Class {
	#name : #ReflectiveRoutesConfigurator,
	#superclass : #Object,
	#instVars : [
		'teapot'
	],
	#category : #'Cosmos-API-Model'
}

{ #category : #'instance creation' }
ReflectiveRoutesConfigurator class >> appliedTo: aTeapot [ 
	
	^ self new initializeAppliedTo: aTeapot 
]

{ #category : #configuring }
ReflectiveRoutesConfigurator >> addRoutesOf: aWebService [

	| configurator |

	configurator := RouteConfigurator
		appliedTo: teapot
		sendingMessagesTo: aWebService.

	(self specifiedRoutesFor: aWebService)
		do: [ :routeSpecification | configurator addFrom: routeSpecification ].

	configurator configureCrossOriginSharingRoutes
]

{ #category : #initialization }
ReflectiveRoutesConfigurator >> initializeAppliedTo: aTeapot [ 
	
	teapot := aTeapot
]

{ #category : #accessing }
ReflectiveRoutesConfigurator >> specifiedRoutesFor: aWebService [

	^ (UnaryMessageSendingCollector
		sendingAllMessagesEndingWith: 'Route'
		to: aWebService specification) value
]
