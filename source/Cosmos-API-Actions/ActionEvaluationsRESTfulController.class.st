Class {
	#name : #ActionEvaluationsRESTfulController,
	#superclass : #ResourceRESTfulController,
	#instVars : [
		'cosmos'
	],
	#category : #'Cosmos-API-Actions'
}

{ #category : #'instance creation' }
ActionEvaluationsRESTfulController class >> workingWith: aCosmosSystem [
	
	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #systems }
ActionEvaluationsRESTfulController >> actionEvaluationSystem [

	^ cosmos >> #ActionEvaluationSystemInterface
]

{ #category : #API }
ActionEvaluationsRESTfulController >> getActionEvaluationSummariesBasedOn: anHttpRequest within: aContext [

	^ self
		get: [ self actionEvaluationSystem actionEvaluationSummaries ]
		asCollectionEncodedUsing: self specification actionEvaluationSummariesMappingKey
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #API }
ActionEvaluationsRESTfulController >> getActionEvaluationsBasedOn: anHttpRequest within: aContext [

	^ self
		get: [ self actionEvaluationSystem actionEvaluations ]
		asCollectionEncodedUsing: self specification actionEvaluationsMappingKey
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #initialization }
ActionEvaluationsRESTfulController >> initializeWorkingWith: aCosmosSystem [
	
	cosmos := aCosmosSystem 
]

{ #category : #'private - accessing' }
ActionEvaluationsRESTfulController >> provideHypermediaPolicy [
	
	^ NonHypermediaDrivenRESTfulControllerPolicy new
]

{ #category : #'private - accessing' }
ActionEvaluationsRESTfulController >> providePaginationPolicy [

	^ RESTfulControllerDoNotPaginateCollectionsPolicy for: self
]

{ #category : #specification }
ActionEvaluationsRESTfulController >> specification [

	^ ActionEvaluationsRESTfulControllerSpecification new
]
