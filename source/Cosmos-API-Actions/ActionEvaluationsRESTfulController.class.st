Class {
	#name : #ActionEvaluationsRESTfulController,
	#superclass : #ResourceRESTfulController,
	#instVars : [
		'cosmos',
		'requestHandler'
	],
	#category : #'Cosmos-API-Actions'
}

{ #category : #'instance creation' }
ActionEvaluationsRESTfulController class >> workingWith: aCosmosSystem [
	
	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #private }
ActionEvaluationsRESTfulController >> actionEvaluationSummariesTemplate [

	^ '<1s>/summaries'
		expandMacrosWith: self endpoint
]

{ #category : #'private - media types' }
ActionEvaluationsRESTfulController >> actionEvaluationSummaryVersion1dot0dot0MediaType [

	^ self jsonMediaType: 'action.evaluation.summary' vendoredBy: 'cosmos' version: '1.0.0'
]

{ #category : #systems }
ActionEvaluationsRESTfulController >> actionEvaluationSystem [

	^ cosmos >> #ActionEvaluationSystemInterface
]

{ #category : #'private - media types' }
ActionEvaluationsRESTfulController >> actionEvaluationVersion1dot0dot0MediaType [
	
	^ self jsonMediaType: 'action.evaluation' vendoredBy: 'cosmos' version: '1.0.0'
]

{ #category : #private }
ActionEvaluationsRESTfulController >> actionEvaluationsTemplate [

	^ '<1s>/last'
		expandMacrosWith: self endpoint
]

{ #category : #'private - encoding and decoding' }
ActionEvaluationsRESTfulController >> configureActionEvaluationEncodingOn: aNeoJSONWriter within: aHttpRequestContext [

	aNeoJSONWriter
		for: ActionEvaluation
			do: [ :mapping | 
			mapping
				mapAccessor: #action;
				mapAccessor: #evaluationDateTime
			];
		for: Action do: [ :mapping | mapping mapAccessor: #name ]
]

{ #category : #'private - encoding and decoding' }
ActionEvaluationsRESTfulController >> configureActionEvaluationSummaryEncodingOn: aNeoJSONWriter within: aHttpRequestContext [ 

	aNeoJSONWriter 
		for: ActionEvaluationSummary
					do: [ :mapping | 
					mapping
						mapAccessor: #action;
						mapAccessor: #lastEvaluation;
						mapAccessor: #evaluationCount ];
				for: Action do: [ :mapping | mapping mapAccessor: #name ]
]

{ #category : #routes }
ActionEvaluationsRESTfulController >> declareGetActionEvaluationSummariesRoute [

	^ RouteSpecification
		handling: #GET
		at: self actionEvaluationSummariesTemplate
		evaluating:
			[ :httpRequest :requestContext | self getActionEvaluationSummariesBasedOn: httpRequest within: requestContext ]
]

{ #category : #routes }
ActionEvaluationsRESTfulController >> declareGetActionEvaluationsRoute [

	^ RouteSpecification
		handling: #GET
		at: self actionEvaluationsTemplate
		evaluating:
			[ :httpRequest :requestContext | self getActionEvaluationsBasedOn: httpRequest within: requestContext ]
]

{ #category : #private }
ActionEvaluationsRESTfulController >> endpoint [

	^ self requestHandler endpoint
]

{ #category : #API }
ActionEvaluationsRESTfulController >> getActionEvaluationSummariesBasedOn: anHttpRequest within: aContext [

	^ self requestHandler
		from: anHttpRequest
		within: aContext
		getCollection: [ self actionEvaluationSystem actionEvaluationSummaries ]
]

{ #category : #API }
ActionEvaluationsRESTfulController >> getActionEvaluationsBasedOn: anHttpRequest within: aContext [

	^ self requestHandler
		from: anHttpRequest
		within: aContext
		getCollection: [ self actionEvaluationSystem actionEvaluations ]
]

{ #category : #initialization }
ActionEvaluationsRESTfulController >> initializeRequestHandler [

	requestHandler := RESTfulRequestHandlerBuilder new
		handling: 'action-evaluations'
			locatingResourcesWith: [ :action :requestContext |  ]
			extractingIdentifierWith: [ :httpRequest |  ];
		whenResponding: self actionEvaluationVersion1dot0dot0MediaType
			encodeToJsonApplying:
				[ :resource :requestContext :writer | self configureActionEvaluationEncodingOn: writer within: requestContext ];
		whenResponding: self actionEvaluationSummaryVersion1dot0dot0MediaType
			encodeToJsonApplying:
				[ :resource :requestContext :writer | self configureActionEvaluationSummaryEncodingOn: writer within: requestContext ];
		createEntityTagHashing: [ :hasher :action :requestContext |  ];
		build
]

{ #category : #initialization }
ActionEvaluationsRESTfulController >> initializeWorkingWith: aCosmosSystem [
	
	cosmos := aCosmosSystem.
	self initializeRequestHandler
]

{ #category : #private }
ActionEvaluationsRESTfulController >> requestHandler [

	^ requestHandler
]

{ #category : #configuring }
ActionEvaluationsRESTfulController >> serverUrl: aServerUrl [

	self requestHandler serverUrl: aServerUrl
]
