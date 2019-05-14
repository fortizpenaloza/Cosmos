"
A TriggeringConditionDecoderTest is a test class for testing the behavior of TriggeringConditionDecoder
"
Class {
	#name : #TriggeringConditionDecoderTest,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'Cosmos-API-Triggers-Tests'
}

{ #category : #running }
TriggeringConditionDecoderTest >> setUp [

	super setUp.

	(SensorsSampleAddOn on: rootSystem) install.

	self actionManagementSystem
		register:
			(Action named: 'Set triggered to true' evaluating: [ "Do nothing" ])
]

{ #category : #'private - running' }
TriggeringConditionDecoderTest >> setUpRequirements [

	self
		registerSubsystem: (TimeSystem using: (FixedTimeSource on: self systemDateTime));
		registerSubsystem: EventNotificationSystem new;
		registerSubsystem: MetadataSystem new;
		registerSubsystem: (IdentifierSystem using: self identifierProvider);
		registerSubsystem: TimestampingSystem new;
		registerSubsystem: DataStreamManagementSystem new;
		registerSubsystem: ActionManagementSystem new
]

{ #category : #'private - accessing' }
TriggeringConditionDecoderTest >> systemDateTime [

	^ DateTime
		date: October first , 2014
		timeOfDay: TimeOfDay noon
		zone: TimeZones buenosAires
]

{ #category : #tests }
TriggeringConditionDecoderTest >> testAndCompositeTriggeringCondition [

	self
		withTriggeringConditionFrom:
			'[{"type":"time_interval","time_interval":{"start":"20:00","stop":"21:00"}},{"type":"data_stream_current_value","data_stream":"Temperature","condition":{"operator":">","value":54}}]'
		do:
			[ :condition | self assert: (condition isKindOf: AndCompositeTriggeringCondition) ]
]

{ #category : #tests }
TriggeringConditionDecoderTest >> testDataStreamCurrentValueTriggeringCondition [

	| json condition |

	json := '[{"type":"data_stream_current_value","data_stream":"Temperature","condition":{"operator":">","value":54}}]'.

	condition := (TriggeringConditionDecoder using: rootSystem)
		decode: (NeoJSONObject fromString: json).


	self
		assert: (condition isKindOf: DataStreamCurrentValueTriggeringCondition)
]

{ #category : #tests }
TriggeringConditionDecoderTest >> testDataStreamHasNotBeenUpdatedTriggeringCondition [

	| json condition |

	json := '[{"type":"data_stream_has_not_been_updated","data_stream":"Temperature","time_period":"5 minutes"}]'.

	condition := (TriggeringConditionDecoder using: rootSystem)
		decode: (NeoJSONObject fromString: json).

	self
		assert: (condition isKindOf: DataStreamHasNotBeenUpdatedTriggeringCondition)
]

{ #category : #tests }
TriggeringConditionDecoderTest >> testEmptyCollectionGivesAlwasyTriggeringCondition [

	self
		withTriggeringConditionFrom: '[]'
		do:
			[ :condition | self assert: (condition isKindOf: AlwaysTriggeringCondition) ]
]

{ #category : #tests }
TriggeringConditionDecoderTest >> testTimeIntervalTriggeringCondition [

	| json condition |

	json := '[{"type":"time_interval","time_interval":{"start":"20:00","stop":"21:00"}}]'.

	condition := (TriggeringConditionDecoder using: rootSystem)
		decode: (NeoJSONObject fromString: json).

	self assert: (condition isKindOf: TimeIntervalTriggeringCondition)
]

{ #category : #'tests support' }
TriggeringConditionDecoderTest >> withTriggeringConditionFrom: aString do: aBlock [

	| condition |

	condition := (TriggeringConditionDecoder using: rootSystem)
		decode: (NeoJSONObject fromString: aString).
	aBlock value: condition
]
