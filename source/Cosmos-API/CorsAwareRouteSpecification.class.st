Class {
	#name : #CorsAwareRouteSpecification,
	#superclass : #Object,
	#instVars : [
		'specification'
	],
	#category : #'Cosmos-API-Model'
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

{ #category : #'as yet unclassified' }
CorsAwareRouteSpecification >> specification [

	^ specification
]
