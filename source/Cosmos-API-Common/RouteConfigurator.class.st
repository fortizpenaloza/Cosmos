Class {
	#name : #RouteConfigurator,
	#superclass : #Object,
	#instVars : [
		'teapot',
		'webService',
		'routesAllowingCors'
	],
	#category : #'Cosmos-API-Common-Model'
}

{ #category : #'instance creation' }
RouteConfigurator class >> appliedTo: aTeapot sendingMessagesTo: aWebService [

	^ self new initializeAppliedTo: aTeapot sendingMessagesTo: aWebService
]

{ #category : #'private - configuring' }
RouteConfigurator >> configureAsCorsAwareRoute: aCorsAwareRouteSpecification [

	| specification |

	specification := aCorsAwareRouteSpecification specification.

	routesAllowingCors
		at: specification resourceLocation
		ifPresent: [ :methods | methods add: specification httpMethod ]
		ifAbsentPut: (OrderedCollection with: specification httpMethod).

	specification accept: self
]

{ #category : #configuring }
RouteConfigurator >> configureCrossOriginSharingRoutes [

	teapot
		OPTIONS:
			routesAllowingCors keys first
				-> (CrossOriginResourceSharingHandler allowing: routesAllowingCors values first)
]

{ #category : #'private - configuring' }
RouteConfigurator >> configureRoute: aRouteSpecification [ 
	
	teapot
		perform: (aRouteSpecification httpMethod , ':') asSymbol
		with:
			aRouteSpecification resourceLocation
				-> [ :request | 
					webService  
						perform: aRouteSpecification message
						with: request
						with: (HttpRequestContext new) ]
]

{ #category : #initialization }
RouteConfigurator >> initializeAppliedTo: aTeapot sendingMessagesTo: aWebService [ 
	
	teapot := aTeapot .
	webService := aWebService.
	
	routesAllowingCors := Dictionary new.
]
