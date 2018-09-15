Class {
	#name : #CorsAwareRouteSpecification,
	#superclass : #Object,
	#instVars : [
		'specification'
	],
	#category : #'Cosmos-API-Common-Model'
}

{ #category : #'instance creation' }
CorsAwareRouteSpecification class >> for: aRouteSpecification [ 
	
	^ self new initializeFor: aRouteSpecification 
]

{ #category : #visiting }
CorsAwareRouteSpecification >> accept: aRouteConfigurator [

	aRouteConfigurator configureAsCorsAwareRoute: self  
]

{ #category : #initialization }
CorsAwareRouteSpecification >> initializeFor: aRouteSpecification [

	specification := aRouteSpecification
]

{ #category : #accessing }
CorsAwareRouteSpecification >> specification [

	^ specification
]
