Class {
	#name : #TriggersAPIInstaller,
	#superclass : #Object,
	#instVars : [
		'server',
		'interface',
		'mappingRegistry'
	],
	#category : #'Cosmos-API-Triggers'
}

{ #category : #'instance creation' }
TriggersAPIInstaller class >> toInstallOn: aServer workingWith: aCosmosSystem [

	^ self new initializeToInstallOn: aServer workingWith: aCosmosSystem
]

{ #category : #'private-installing' }
TriggersAPIInstaller >> addGetTriggersRoute [

	server
		GET: '/triggers' -> [ :request | interface triggersHandling: request ].
		
	self registerTriggerJsonEncoderVersion1dot0dot0
]

{ #category : #'private-installing' }
TriggersAPIInstaller >> addRegisterTriggerRoute [

	server
		POST: '/triggers' -> [ :request | interface registerHandling: request ];
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

{ #category : #accessing }
TriggersAPIInstaller >> applicationJsonVersion1dot0dot0 [

	^ ZnMimeType
		fromString: 'application/vnd.cosmos.trigger+json; version=1.0.0'
]

{ #category : #initialization }
TriggersAPIInstaller >> initializeToInstallOn: aServer workingWith: aCosmosSystem [

	mappingRegistry := MappingRuleSet new.
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
		add: self triggerJsonDecoderVersion1dot0dot0
		asDecoderFor: self applicationJsonVersion1dot0dot0
		at: #triggers
]

{ #category : #'private-installing' }
TriggersAPIInstaller >> registerTriggerJsonEncoderVersion1dot0dot0 [

	mappingRegistry
		add: self triggerJsonEnconderVersion1dot0dot0
		asEncoderFor: self applicationJsonVersion1dot0dot0
		at: #triggers
]

{ #category : #'private-encoding' }
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

{ #category : #'private-encoding' }
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
				prettyPrint: true;
				nextPut: trigger ] ]
]
