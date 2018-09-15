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
RouteConfigurator class >> appliedTo: aTeapot sendingMessagesTo: aWebService [

	^ self new initializeAppliedTo: aTeapot sendingMessagesTo: aWebService
]

{ #category : #configuring }
RouteConfigurator >> addFrom: aRouteSpecification [

	aRouteSpecification accept: self

]

{ #category : #'private - configuring' }
RouteConfigurator >> configureAsCorsAwareRoute: aCorsAwareRouteSpecification [

	| spec |

	spec := aCorsAwareRouteSpecification specification.

	routesAllowingCors
		at: spec resourceLocation
		ifPresent: [ :methods | methods add: spec httpMethod ]
		ifAbsentPut: (OrderedCollection with: spec httpMethod).

	spec accept: self
]

{ #category : #configuring }
RouteConfigurator >> configureCrossOriginSharingRoutes [

	teapot
		OPTIONS:
			routesAllowingCors keys first
				-> (CrossOriginResourceSharingHandler allowing: routesAllowingCors values first)
]

{ #category : #'private - configuring' }
RouteConfigurator >> configureRouteFrom: aRouteSpecification [ 
	
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
