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
		on: teapot
		sendingMessagesTo: aWebService.

	(self specifiedRoutesOn: aWebService specification)
		do: [ :route | configurator configure: route ].

	configurator installCrossOriginSharingRoutes
]

{ #category : #initialization }
ReflectiveRoutesConfigurator >> initializeAppliedTo: aTeapot [ 
	
	teapot := aTeapot 
]

{ #category : #accessing }
ReflectiveRoutesConfigurator >> specifiedRoutesOn: aWebServiceSpecification [

	^ (UnaryMessageSendingCollector
		sendingAllMessagesEndingWith: 'Route'
		to: aWebServiceSpecification) value
]
