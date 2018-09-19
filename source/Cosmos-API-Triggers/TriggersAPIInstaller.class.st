Class {
	#name : #TriggersAPIInstaller,
	#superclass : #Object,
	#instVars : [
		'server',
		'interface',
		'mappingRuleSetBuilder'
	],
	#category : #'Cosmos-API-Triggers'
}

{ #category : #'instance creation' }
TriggersAPIInstaller class >> toInstallOn: aServer workingWith: aCosmosSystem [

	^ self new initializeToInstallOn: aServer workingWith: aCosmosSystem
]

{ #category : #'installing - routes' }
TriggersAPIInstaller >> addCrossOriginResourceSharingRouteXX [

	server
		OPTIONS:
			'/triggers'
				-> [ :request | 
					| response |

					response := ZnResponse noContent.

					response headers
						at: 'Access-Control-Allow-Headers' put: 'Access-Control-Allow-Origin, Content-Type, Accept';
						at: 'Access-Control-Allow-Methods' put: 'POST, GET, DELETE, PUT';
						at: 'Access-Control-Max-Age' put: '86400'.

					response ]
]

{ #category : #'installing - routes' }
TriggersAPIInstaller >> addGetTriggersRoute [

	server
		GET: '/triggers' -> [ :request | interface triggersHandling: request ]
]

{ #category : #'installing - routes' }
TriggersAPIInstaller >> addRegisterTriggerRoute [

	server
		POST: '/triggers' -> [ :request | interface registerHandling: request ];
		output: #text
]

{ #category : #'installing - routes' }
TriggersAPIInstaller >> addUnregisterTriggerRoute [

	server
		DELETE:
			'/triggers/<name>'
				-> [ :request | 
					interface
						deregisterNamed: ((request at: #name) replaceAll: $_ with: Character space) ];
		output: #text
]

{ #category : #'media types' }
TriggersAPIInstaller >> applicationJsonVersion1dot0dot0 [

	^ ZnMimeType
		fromString: 'application/vnd.cosmos.trigger+json; version=1.0.0'
]

{ #category : #initialization }
TriggersAPIInstaller >> initializeToInstallOn: aServer workingWith: aCosmosSystem [

	mappingRuleSetBuilder := MappingRuleSetBuilder new.

	self 
		registerTriggerJsonEncoderVersion1dot0dot0;
		registerTriggerJsonDecoderVersion1dot0dot0.

	interface := TriggersAPI
		workingWithin:
			(TriggersAPIContext
				workingWith: aCosmosSystem
				queryingMappingsTo: mappingRuleSetBuilder build).

	server := aServer
]

{ #category : #installing }
TriggersAPIInstaller >> install [

	self
		addGetTriggersRoute;
		addRegisterTriggerRoute;
		addUnregisterTriggerRoute;
		addCrossOriginResourceSharingRouteXX.
		
	^ interface
]

{ #category : #'installing - encoders and decoders' }
TriggersAPIInstaller >> registerTriggerJsonDecoderVersion1dot0dot0 [

	mappingRuleSetBuilder
		addDefaultRuleToDecode: self applicationJsonVersion1dot0dot0
		to: #triggers
		using: self triggerJsonDecoderVersion1dot0dot0
]

{ #category : #'installing - encoders and decoders' }
TriggersAPIInstaller >> registerTriggerJsonEncoderVersion1dot0dot0 [

	mappingRuleSetBuilder
		addDefaultRuleToEncode: #triggers
		to: self applicationJsonVersion1dot0dot0
		using: self triggerJsonEnconderVersion1dot0dot0
]

{ #category : #'encoders and decoders' }
TriggersAPIInstaller >> triggerJsonDecoderVersion1dot0dot0 [

	^ [ :aJSON :context | 
	(NeoJSONReader on: aJSON readStream)
		for: #TriggerRegistration
			customDo: [ :mapping | 
			mapping
				decoder: [ :rawTrigger | 
					context triggerManagementSystem
						registerNamed: (rawTrigger at: #name)
						triggering: (context decodeActionFrom: rawTrigger)
						accordingTo: (context decodeTriggeringPolicyFrom: rawTrigger)
						whenMeets: (context decodeTriggeringConditionFrom: rawTrigger) ] ];
		propertyNamesAsSymbols: true;
		nextAs: #TriggerRegistration ]
]

{ #category : #'encoders and decoders' }
TriggersAPIInstaller >> triggerJsonEnconderVersion1dot0dot0 [

	^ [ :trigger | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: ActionTrigger
					do: [ :mapping | 
					mapping
						mapAccessor: #name;
						mapAccessor: #creationDateTime to: 'created_on';
						mapInstVar: #action;
						mapAccessor: #triggeringPolicy to: 'policy'.
					(mapping mapInstVar: #condition to: #conditions) valueSchema: #Conditions ];
				for: #Conditions
					customDo: [ :mapping | 
					mapping
						encoder: [ :condition | 
							| mappings |

							mappings := Dictionary new.
							mappings
								at: AndCompositeTriggeringCondition
									put: [ Array withAll: (condition instVarNamed: #triggerConditions) ];
								at: AlwaysTriggeringCondition put: [ Array empty ];
								at: DataStreamCurrentValueTriggeringCondition
									put: [ Array
										with:
											(OrderedDictionary new
												at: #type put: #data_stream_current_value;
												at: #data_stream put: (condition instVarNamed: #dataStream) name;
												at: #condition put: (condition instVarNamed: #condition);
												yourself) ];
								at: TimeIntervalTriggeringCondition
									put: [ Array
										with:
											(OrderedDictionary new
												at: #type put: #time_interval;
												at: #from put: (condition instVarNamed: #timeInterval) from;
												at: #to put: (condition instVarNamed: #timeInterval) to;
												yourself) ];
								yourself.
							(mappings at: condition class) value ] ];
				for: TimeIntervalTriggeringCondition
					customDo: [ :mapping | 
					mapping
						encoder: [ :condition | 
							OrderedDictionary new
								at: #type put: #time_interval;
								at: #from put: (condition instVarNamed: #timeInterval) from;
								at: #to put: (condition instVarNamed: #timeInterval) to;
								yourself ] ];
				for: DataStreamCurrentValueTriggeringCondition
					customDo: [ :mapping | 
					mapping
						encoder: [ :condition | 
							OrderedDictionary new
								at: #type put: #data_stream_current_value;
								at: #data_stream put: (condition instVarNamed: #dataStream) name;
								at: #condition put: (condition instVarNamed: #condition);
								yourself ] ];
				for: Action
					customDo: [ :mapping | mapping encoder: [ :action | action name ] ];
				for: PeriodicalTriggeringPolicy
					customDo: [ :mapping | 
					mapping
						encoder: [ :policy | 
							{(#type -> #periodical).
							(#time_interval -> (policy instVarNamed: #timePeriod))} asOrderedDictionary ] ];
				for: DataPointRegistrationTriggeringPolicy
					customDo: [ :mapping | 
					mapping
						encoder: [ :policy | 
							{(#type -> #on_data_point_registration).
							(#data_stream -> ((policy instVarNamed: #dataStream) instVarNamed: #name))}
								asOrderedDictionary ] ];
				for: ArithmeticCondition
					do: [ :mapping | 
					mapping
						mapInstVar: #arithmeticOperator to: #operator;
						mapInstVar: #value ];
				for: Measure
					customDo: [ :mapping | mapping encoder: [ :measure | measure printString ] ];
				for: TimeOfDay
					customDo: [ :mapping | mapping encoder: [ :timeOfDay | timeOfDay printString ] ];
				for: DateTime
					customDo: [ :mapping | 
					mapping
						encoder: [ :dateTime | ISO8601DateTimeFormatter usingExtendedFormat format: dateTime ] ];
				nextPut: trigger ] ]
]
