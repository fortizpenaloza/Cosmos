Class {
	#name : #TriggersRESTfulControllerSpecification,
	#superclass : #ResourceRESTfulControllerSpecification,
	#category : #'Cosmos-API-Triggers'
}

{ #category : #'specification - encoders and decoders' }
TriggersRESTfulControllerSpecification >> addTriggerJsonDecoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToDecode: self applicationJsonVersion1dot0dot0MediaType
		to: self triggerMappingKey
		using: self triggerJsonDecoderVersion1dot0dot0
]

{ #category : #'specification - encoders and decoders' }
TriggersRESTfulControllerSpecification >> addTriggerJsonEncoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToEncode: self triggersMappingKey
		to: self applicationJsonVersion1dot0dot0MediaType
		using: self triggersJsonEnconderVersion1dot0dot0.

	aBuilder
		addDefaultRuleToEncode: self triggerMappingKey
		to: self applicationJsonVersion1dot0dot0MediaType
		using: self triggerJsonEnconderVersion1dot0dot0
]

{ #category : #'media types' }
TriggersRESTfulControllerSpecification >> applicationJsonVersion1dot0dot0MediaType [

	^ 'application/json;version=1.0.0' asMediaType
]

{ #category : #'specification - routes' }
TriggersRESTfulControllerSpecification >> createTriggerRoute [

	^ (RouteSpecification
		handling: #POST
		at: self endpoint
		sending: #createTriggerBasedOn:within:) asCorsAware
]

{ #category : #'specification - routes' }
TriggersRESTfulControllerSpecification >> deleteTriggerRoute [

	^ (RouteSpecification 
		handling: #DELETE
		at: self idTemplate
		sending: #deleteTriggerBasedOn:within:) asCorsAware 
		
	
]

{ #category : #accessing }
TriggersRESTfulControllerSpecification >> endpoint [

	^ '/triggers'
]

{ #category : #'specification - routes' }
TriggersRESTfulControllerSpecification >> getTriggerRoute [

	^ RouteSpecification
		handling: #GET
		at: self idTemplate
		sending: #getTriggerBasedOn:within:
]

{ #category : #'specification - routes' }
TriggersRESTfulControllerSpecification >> getTriggersRoute [

	^ RouteSpecification
		handling: #GET
		at: self endpoint 
		sending: #getTriggersBasedOn:within:
]

{ #category : #accessing }
TriggersRESTfulControllerSpecification >> idTemplate [

	^ '<1s>/%<<2s>:IsUUID>' expandMacrosWith: self endpoint with: self identifierKey
]

{ #category : #accessing }
TriggersRESTfulControllerSpecification >> identifierKey [

	^ #identifier
]

{ #category : #'encoders and decoders' }
TriggersRESTfulControllerSpecification >> triggerJsonDecoderVersion1dot0dot0 [

	^ [ :json :context | 
	(NeoJSONReader on: json readStream)
		for: ActionTrigger
			customDo: [ :mapping | 
			mapping
				decoder: [ :rawTrigger | 
					ActionTrigger
						named: (rawTrigger at: #name)
						triggering: (context decodeActionFrom: rawTrigger)
						accordingTo: (context decodeTriggeringPolicyFrom: rawTrigger)
						ifSatisfies: (context decodeTriggeringConditionFrom: rawTrigger) ] ];
		propertyNamesAsSymbols: true;
		nextAs: ActionTrigger ]
]

{ #category : #'encoders and decoders' }
TriggersRESTfulControllerSpecification >> triggerJsonEnconderVersion1dot0dot0 [

	^ [ :trigger :context | 
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
						valueSchema: #Conditions.
					mapping mapHypermediaControlsIn: context ];
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
				nextPut: trigger] ]
]

{ #category : #'specification - encoders and decoders' }
TriggersRESTfulControllerSpecification >> triggerMappingKey [

	^ #trigger
]

{ #category : #'encoders and decoders' }
TriggersRESTfulControllerSpecification >> triggersJsonEnconderVersion1dot0dot0 [

	^ [ :triggers :context | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: ActionTrigger
					do: [ :mapping | 
					mapping
						mapAccessor: #name;
						mapInstVar: #action;
						mapAccessor: #triggeringPolicy to: 'policy'.
					(mapping mapInstVar: #condition to: #conditions) valueSchema: #Conditions.
					mapping mapAsHypermediaControls: [ :actionTrigger | context hypermediaControlsFor: actionTrigger ] ];
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
				for: DateTime
					customDo:
						[ :mapping | mapping encoder: [ :dateTime | ISO8601DateTimeFormatter usingExtendedFormat format: dateTime ] ];
				nextPut: triggers ] ]
]

{ #category : #'specification - encoders and decoders' }
TriggersRESTfulControllerSpecification >> triggersMappingKey [

	^ #triggers
]
