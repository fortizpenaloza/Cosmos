Class {
	#name : #ActionEvaluationSummariesRESTfulController,
	#superclass : #ResourceRESTfulController,
	#instVars : [
		'cosmos'
	],
	#category : #'Cosmos-API-Actions'
}

{ #category : #'instance creation' }
ActionEvaluationSummariesRESTfulController class >> workingWith: aCosmosSystem [
	
	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #'private - systems' }
ActionEvaluationSummariesRESTfulController >> actionManagementSystem [

	^ cosmos >> #ActionManagementSystemInterface
]

{ #category : #API }
ActionEvaluationSummariesRESTfulController >> getActionEvaluationSummariesBasedOn: anHttpRequest within: aContext [

	^ self
		get: [ self actionManagementSystem actionEvaluationSummaries ]
		asCollectionEncodedUsing: self specification actionEvaluationSummariesMappingKey
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #initialization }
ActionEvaluationSummariesRESTfulController >> initializeWorkingWith: aCosmosSystem [
	
	cosmos := aCosmosSystem 
]

{ #category : #'private - accessing' }
ActionEvaluationSummariesRESTfulController >> provideHypermediaPolicy [
	
	^ NonHypermediaDrivenRESTfulControllerPolicy new
]

{ #category : #'private - accessing' }
ActionEvaluationSummariesRESTfulController >> providePaginationPolicy [

	^ RESTfulControllerDoNotPaginateCollectionsPolicy for: self
]

{ #category : #specification }
ActionEvaluationSummariesRESTfulController >> specification [

	^ ActionEvaluationSummariesRESTfulControllerSpecification new
]
