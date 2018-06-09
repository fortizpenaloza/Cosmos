Class {
	#name : #TriggersAPIInstaller,
	#superclass : #Object,
	#instVars : [
		'server',
		'interface',
		'mappingRegistry'
	],
	#category : #'Cosmos-API-Triggers-Model'
}

{ #category : #'instance creation' }
TriggersAPIInstaller class >> toInstallOn: aServer workingWith: aCosmosSystem [

	^ self new initializeToInstallOn: aServer workingWith: aCosmosSystem
]

{ #category : #'private-installing' }
TriggersAPIInstaller >> addGetTriggersRoute [

	server
		GET: '/triggers' -> [ :request | interface triggersFor: request ].
		
	self registerTriggerJsonEncoderVersion1dot0dot0
]

{ #category : #'private-installing' }
TriggersAPIInstaller >> addRegisterTriggerRoute [

	server
		POST: '/triggers' -> [ :request | interface registerFrom: request ];
		output: #text.
		
	self registerTriggerJsonDecoderVersion1dot0dot0
]

{ #category : #'private-installing' }
TriggersAPIInstaller >> addUnregisterTriggerRoute [

	server
		DELETE:
			'/triggers/<name>'
				-> [ :request | 
					interface
						deregisterNamed: ((request at: #name) replaceAll: $_ with: Character space) ];
		output: #text
]

{ #category : #initialization }
TriggersAPIInstaller >> initializeToInstallOn: aServer workingWith: aCosmosSystem [

	mappingRegistry := MappingRegistry new.
	interface := TriggersAPI
		workingWithin: (TriggersAPIContext workingWith: aCosmosSystem queryingMappingsTo: mappingRegistry).
	server := aServer
]

{ #category : #installing }
TriggersAPIInstaller >> install [

	self
		addGetTriggersRoute;
		addRegisterTriggerRoute;
		addUnregisterTriggerRoute.
		
	^ interface
]

{ #category : #'private-installing' }
TriggersAPIInstaller >> registerTriggerJsonDecoderVersion1dot0dot0 [

	mappingRegistry
		register: self triggerJsonDecoderVersion1dot0dot0
		asDecoderFor: self triggerJsonVersion1dot0dot0MimeType
]

{ #category : #'private-installing' }
TriggersAPIInstaller >> registerTriggerJsonEncoderVersion1dot0dot0 [

	mappingRegistry
		register: self triggerJsonEnconderVersion1dot0dot0
		asEncoderFor: self triggerJsonVersion1dot0dot0MimeType
]

{ #category : #'private-encoding' }
TriggersAPIInstaller >> triggerJsonDecoderVersion1dot0dot0 [

	^ [ :aJSON :context | 
	| rawTrigger |

	rawTrigger := (NeoJSONReader on: aJSON readStream)
		propertyNamesAsSymbols: true;
		next.

	context triggerManagementSystem
		registerNamed: (rawTrigger at: #name)
		triggering: (context decodeActionFrom: rawTrigger)
		accordingTo: (context parseTriggeringPolicyFrom: rawTrigger)
		whenMeets: (context parseConditionFrom: rawTrigger) ]
]

{ #category : #'private-encoding' }
TriggersAPIInstaller >> triggerJsonEnconderVersion1dot0dot0 [

	^ [ :object | 
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
					(mapping mapInstVar: #condition to: #conditions) valueSchema: #Bleh ];
				for: #Bleh
					customDo: [ :mapping | 
					mapping
						encoder: [ :condition | 
							| mappings |

							mappings := Dictionary new.
							mappings
								at: AndCompositeTriggeringCondition put: [ Array withAll: (condition instVarNamed: #triggerConditions) ];
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
				for: Action customDo: [ :mapping | mapping encoder: [ :action | action name ] ];
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
							(#data_stream -> ((policy instVarNamed: #dataStream) instVarNamed: #name))} asOrderedDictionary ] ];
				for: ArithmeticCondition
					do: [ :mapping | 
					mapping
						mapInstVar: #arithmeticOperator to: #operator;
						mapInstVar: #value ];
				for: Measure customDo: [ :mapping | mapping encoder: [ :measure | measure printString ] ];
				for: TimeOfDay customDo: [ :mapping | mapping encoder: [ :timeOfDay | timeOfDay printString ] ];
				for: DateTime customDo: [ :mapping | mapping encoder: [ :dateTime | ISO8601DateTimeFormatter usingExtendedFormat format: dateTime ] ];
				prettyPrint: true;
				nextPut: object ] ]
]

{ #category : #accessing }
TriggersAPIInstaller >> triggerJsonVersion1dot0dot0MimeType [

	^ ZnMimeType
		fromString: 'application/vnd.cosmos.trigger+json; version=1.0.0'
]
