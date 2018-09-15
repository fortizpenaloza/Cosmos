Class {
	#name : #AllowingCrossOriginResourceSharingDecorator,
	#superclass : #Object,
	#instVars : [
		'routeSpecification'
	],
	#category : #'Cosmos-API-Model'
}

{ #category : #'instance creation' }
AllowingCrossOriginResourceSharingDecorator class >> decorating: aRouteSpecification [ 
	
	^ self new initializeDecorating: aRouteSpecification 
]

{ #category : #initialization }
AllowingCrossOriginResourceSharingDecorator >> initializeDecorating: aRouteSpecification [

	routeSpecification := aRouteSpecification
]
