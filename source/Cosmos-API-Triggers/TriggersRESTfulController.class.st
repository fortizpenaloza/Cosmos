Class {
	#name : #TriggersRESTfulController,
	#superclass : #SingleResourceRESTfulController,
	#instVars : [
		'cosmos',
		'requestHandler'
	],
	#category : #'Cosmos-API-Triggers'
}

{ #category : #'instance creation' }
TriggersRESTfulController class >> workingWith: aCosmosSystem [
	
	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #'private - encoding and decoding' }
TriggersRESTfulController >> configureTriggerDecodingOn: aReader [

	^ aReader
		for: ActionTrigger
			customDo:
				[ :mapping | mapping decoder: [ :rawTrigger | ( ActionTriggerDecoder using: cosmos ) decode: rawTrigger ] ];
		nextAs: ActionTrigger
]

{ #category : #'private - encoding and decoding' }
TriggersRESTfulController >> configureTriggerEncodingOn: aWriter within: aRequestContext [

	aWriter
		for: ActionTrigger
			do: [ :mapping | 
			mapping
				mapAccessor: #name;
				mapInstVar: #action;
				mapAccessor: #triggeringPolicy to: 'policy'.
			( mapping mapInstVar: #condition to: #conditions ) valueSchema: #Conditions.
			mapping mapAsHypermediaControls: [ :action | aRequestContext hypermediaControlsFor: action ]
			];
		for: #Conditions
			customDo: [ :mapping | 
			mapping
				encoder: [ :condition | 
					| mappings |

					mappings := Dictionary new.
					mappings
						at: AndCompositeTriggeringCondition
							put: [ Array withAll: ( condition instVarNamed: #triggerConditions ) ];
						at: AlwaysTriggeringCondition put: [ Array empty ];
						at: DataStreamCurrentValueTriggeringCondition
							put: [ Array
								with:
									( OrderedDictionary new
										at: #type put: #data_stream_current_value;
										at: #data_stream put: ( condition instVarNamed: #dataStream ) name;
										at: #condition put: ( condition instVarNamed: #condition );
										yourself )
							];
						at: TimeIntervalTriggeringCondition
							put: [ Array
								with:
									( OrderedDictionary new
										at: #type put: #time_interval;
										at: #from put: ( condition instVarNamed: #timeInterval ) from;
										at: #to put: ( condition instVarNamed: #timeInterval ) to;
										yourself )
							];
						yourself.
					( mappings at: condition class ) value
					]
			];
		for: TimeIntervalTriggeringCondition
			customDo: [ :mapping | 
			mapping
				encoder: [ :condition | 
					OrderedDictionary new
						at: #type put: #time_interval;
						at: #from put: ( condition instVarNamed: #timeInterval ) from;
						at: #to put: ( condition instVarNamed: #timeInterval ) to;
						yourself
					]
			];
		for: DataStreamCurrentValueTriggeringCondition
			customDo: [ :mapping | 
			mapping
				encoder: [ :condition | 
					OrderedDictionary new
						at: #type put: #data_stream_current_value;
						at: #data_stream put: ( condition instVarNamed: #dataStream ) name;
						at: #condition put: ( condition instVarNamed: #condition );
						yourself
					]
			];
		for: Action customDo: [ :mapping | mapping encoder: [ :action | action name ] ];
		for: PeriodicalTriggeringPolicy
			customDo: [ :mapping | 
			mapping
				encoder: [ :policy | 
					{( #type -> #periodical ).
					( #time_interval -> ( policy instVarNamed: #timePeriod ) )} asOrderedDictionary
					]
			];
		for: DataPointRegistrationTriggeringPolicy
			customDo: [ :mapping | 
			mapping
				encoder: [ :policy | 
					{( #type -> #on_data_point_registration ).
					( #data_stream -> ( ( policy instVarNamed: #dataStream ) instVarNamed: #name ) )}
						asOrderedDictionary
					]
			];
		for: ArithmeticCondition
			do: [ :mapping | 
			mapping
				mapInstVar: #arithmeticOperator to: #operator;
				mapInstVar: #value
			];
		for: Measure customDo: [ :mapping | mapping encoder: [ :measure | measure printString ] ];
		for: TimeOfDay customDo: [ :mapping | mapping encoder: [ :timeOfDay | timeOfDay printString ] ]
]

{ #category : #API }
TriggersRESTfulController >> createTriggerBasedOn: anHttpRequest within: aContext [

	^ self requestHandler
		withResourceCreatedFrom: anHttpRequest
		within: aContext
		do: [ :trigger | 
			self triggerManagementSystem register: trigger.
			aContext hold: cosmos under: #cosmos.
			trigger
			]
]

{ #category : #routes }
TriggersRESTfulController >> declareCreateTriggerRoute [

	^ ( RouteSpecification
		handling: #POST
		at: self endpoint
		evaluating: [ :httpRequest :requestContext | self createTriggerBasedOn: httpRequest within: requestContext ] )
		asCorsAware
]

{ #category : #routes }
TriggersRESTfulController >> declareDeleteTriggerRoute [

	^ ( RouteSpecification
		handling: #DELETE
		at: self identifierTemplate
		evaluating: [ :httpRequest :requestContext | self deleteTriggerBasedOn: httpRequest within: requestContext ] )
		asCorsAware
]

{ #category : #routes }
TriggersRESTfulController >> declareGetTriggerRoute [

	^ RouteSpecification
		handling: #GET
		at: self identifierTemplate
		evaluating: [ :httpRequest :requestContext | self getTriggerBasedOn: httpRequest within: requestContext ]
]

{ #category : #routes }
TriggersRESTfulController >> declareGetTriggersRoute [

	^ RouteSpecification
		handling: #GET
		at: self endpoint
		evaluating: [ :httpRequest :requestContext | self getTriggersBasedOn: httpRequest within: requestContext ]
]

{ #category : #API }
TriggersRESTfulController >> deleteTriggerBasedOn: anHttpRequest within: aRequestContext [

	^ self requestHandler
		from: anHttpRequest
		within: aRequestContext
		get: [ :identifier | self triggerManagementSystem triggerIdentifiedBy: identifier ]
		thenDo: [ :action | self triggerManagementSystem deregister: action ]
]

{ #category : #API }
TriggersRESTfulController >> getTriggerBasedOn: anHttpRequest within: aContext [

	^ self requestHandler
		from: anHttpRequest
		within: aContext
		get: [ :identifier | self triggerManagementSystem triggerIdentifiedBy: identifier ]
]

{ #category : #API }
TriggersRESTfulController >> getTriggersBasedOn: anHttpRequest within: aContext [

	^ self requestHandler
		from: anHttpRequest
		within: aContext
		getCollection: [ self triggerManagementSystem triggers ]
]

{ #category : #'private - API' }
TriggersRESTfulController >> identifierOf: anActionTrigger [

	^ self identifierSystem identifierOf: anActionTrigger
]

{ #category : #'private - systems' }
TriggersRESTfulController >> identifierSystem [

	^ cosmos >> #IdentifierSystemInterface
]

{ #category : #initialization }
TriggersRESTfulController >> initializeRequestHandler [

	requestHandler := RESTfulRequestHandlerBuilder new
		handling: 'triggers'
			locatingResourcesWith: [ :trigger :requestContext | self identifierOf: trigger ]
			extractingIdentifierWith: [ :httpRequest | self identifierIn: httpRequest ];
		beHypermediaDriven;
		whenAccepting: self triggerVersion1dot0dot0MediaType
			decodeFromJsonApplying: [ :json :reader | self configureTriggerDecodingOn: reader ];
		whenResponding: self triggerVersion1dot0dot0MediaType
			encodeToJsonApplying:
				[ :resource :requestContext :writer | self configureTriggerEncodingOn: writer within: requestContext ];
		createEntityTagHashing: [ :hasher :trigger :requestContext | 
			hasher
				include: ( self identifierOf: trigger );
				include: ( self lastModificationOf: trigger )
			];
		build
]

{ #category : #initialization }
TriggersRESTfulController >> initializeWorkingWith: aCosmosSystem [

	cosmos := aCosmosSystem.
	self initializeRequestHandler
]

{ #category : #'private - API' }
TriggersRESTfulController >> lastModificationOf: anActionTrigger [

	^ self timestampingSystem lastModificationOf: anActionTrigger
]

{ #category : #private }
TriggersRESTfulController >> requestHandler [

	^ requestHandler
]

{ #category : #'private - systems' }
TriggersRESTfulController >> timestampingSystem [
	
	^ cosmos >> #TimestampingSystemInterface
]

{ #category : #'private - systems' }
TriggersRESTfulController >> triggerManagementSystem [
	
	^ cosmos >> #TriggerManagementSystemInterface
]

{ #category : #'media types' }
TriggersRESTfulController >> triggerVersion1dot0dot0MediaType [

	^ self jsonMediaType: 'trigger' vendoredBy: 'cosmos' version: '1.0.0'
]

{ #category : #private }
TriggersRESTfulController >> typeIdConstraint [

	^ IsUUID 
]
