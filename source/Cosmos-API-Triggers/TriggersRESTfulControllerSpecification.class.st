Class {
	#name : #TriggersRESTfulControllerSpecification,
	#superclass : #ResourceRESTFulControllerSpecification,
	#category : #'Cosmos-API-Triggers'
}

{ #category : #'specification - encoders and decoders' }
TriggersRESTfulControllerSpecification >> addTriggerJsonDecoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToDecode: self applicationJsonVersion1dot0dot0MediaType
		to: #triggers
		using: self triggerJsonDecoderVersion1dot0dot0
]

{ #category : #'specification - encoders and decoders' }
TriggersRESTfulControllerSpecification >> addTriggerJsonEncoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToEncode: #triggers
		to: self applicationJsonVersion1dot0dot0MediaType
		using: self triggerJsonEnconderVersion1dot0dot0
]

{ #category : #'media types' }
TriggersRESTfulControllerSpecification >> applicationJsonVersion1dot0dot0MediaType [

	^ 'application/json;version=1.0.0' asZnMimeType
]

{ #category : #'specification - routes' }
TriggersRESTfulControllerSpecification >> createTriggerRoute [

	^ RouteSpecification 
		handling: #POST
		at: '/triggers'
		sending: #createTriggerBasedOn:within:
]

{ #category : #'specification - routes' }
TriggersRESTfulControllerSpecification >> deleteTriggerRoute [

	^ RouteSpecification 
		handling: #DELETE
		at: '/triggers/<name>'
		sending: #deregisterNamed:
]

{ #category : #'specification - routes' }
TriggersRESTfulControllerSpecification >> getTriggersRoute [

	^ RouteSpecification
		handling: #GET
		at: '/triggers'
		sending: #getTriggersBasedOn:within:
]

{ #category : #'encoders and decoders' }
TriggersRESTfulControllerSpecification >> triggerJsonDecoderVersion1dot0dot0 [

	^ [ :aJSON :context | 
	(NeoJSONReader on: aJSON readStream)
		for: #TriggerRegistration
			customDo: [ :mapping | 
			mapping
				decoder: [ :rawTrigger | 
					ActionTrigger
						named: (rawTrigger at: #name)
						triggering: (context decodeActionFrom: rawTrigger)
						accordingTo: (context decodeTriggeringPolicyFrom: rawTrigger)
						ifSatisfies: (context decodeTriggeringConditionFrom: rawTrigger) ] ];
		propertyNamesAsSymbols: true;
		nextAs: #TriggerRegistration ]
]

{ #category : #'encoders and decoders' }
TriggersRESTfulControllerSpecification >> triggerJsonEnconderVersion1dot0dot0 [

	^ [ :trigger | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: ActionTrigger
					do: [ :mapping | 
					mapping
						mapAccessor: #name;
						mapInstVar: #action;
						mapAccessor: #triggeringPolicy to: 'policy'.
					(mapping mapInstVar: #condition to: #conditions)
						valueSchema: #Conditions ];
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
												at: #data_stream
													put: (condition instVarNamed: #dataStream) name;
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
								at: #data_stream
									put: (condition instVarNamed: #dataStream) name;
								at: #condition put: (condition instVarNamed: #condition);
								yourself ] ];
				for: Action
					customDo: [ :mapping | mapping encoder: [ :action | action name ] ];
				for: PeriodicalTriggeringPolicy
					customDo: [ :mapping | 
					mapping
						encoder: [ :policy | 
							{(#type -> #periodical).
							(#time_interval -> (policy instVarNamed: #timePeriod))}
								asOrderedDictionary ] ];
				for: DataPointRegistrationTriggeringPolicy
					customDo: [ :mapping | 
					mapping
						encoder: [ :policy | 
							{(#type -> #on_data_point_registration).
							(#data_stream
								-> ((policy instVarNamed: #dataStream) instVarNamed: #name))}
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
						encoder:
							[ :dateTime | ISO8601DateTimeFormatter usingExtendedFormat format: dateTime ] ];
				nextPut: trigger ] ]
]
