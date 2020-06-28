"
A TriggeringConditionDecoderTest is a test class for testing the behavior of TriggeringConditionDecoder
"
Class {
	#name : #TriggeringConditionDecoderTest,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'Cosmos-API-Triggers-Tests'
}

{ #category : #'tests support' }
TriggeringConditionDecoderTest >> dateTime [

	^ October first , 2014 atTimeOfDay: ( TimeOfDay hours: 12 minutes: 6 )
]

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
			'[{"type":"time_interval","time_interval":{"start":"20:00","stop":"22:00"}},{"type":"data_stream_current_value","data_stream":"Temperature","condition":{"operator":">","value":16}}]'
		do: [ :condition | 
			self
				assert: ( condition isKindOf: AndCompositeTriggeringCondition );
				assert: ( condition isSatisfiedOn: self )
			]
]

{ #category : #tests }
TriggeringConditionDecoderTest >> testDataStreamCurrentValueTriggeringCondition [

	self
		withTriggeringConditionFrom:
			'[{"type":"data_stream_current_value","data_stream":"Temperature","condition":{"operator":">","value":16}}]'
		do: [ :condition | 
			self
				assert: ( condition isKindOf: DataStreamCurrentValueTriggeringCondition );
				assert: ( condition isSatisfiedOn: self )
			]
]

{ #category : #tests }
TriggeringConditionDecoderTest >> testDataStreamHasNotBeenUpdatedTriggeringCondition [

	self
		withTriggeringConditionFrom:
			'[{"type":"data_stream_has_not_been_updated","data_stream":"Temperature","time_period":"5 minutes"}]'
		do: [ :condition | 
			self
				assert: ( condition isKindOf: DataStreamHasNotBeenUpdatedTriggeringCondition );
				assert: ( condition isSatisfiedOn: self )
			]
]

{ #category : #tests }
TriggeringConditionDecoderTest >> testEmptyCollectionGivesAlwasyTriggeringCondition [

	self
		withTriggeringConditionFrom: '[]'
		do: [ :condition | 
			self
				assert: ( condition isKindOf: AlwaysTriggeringCondition );
				assert: ( condition isSatisfiedOn: self )
			]
]

{ #category : #tests }
TriggeringConditionDecoderTest >> testTimeIntervalTriggeringCondition [

	self
		withTriggeringConditionFrom: '[{"type":"time_interval","time_interval":{"start":"20:00","stop":"22:00"}}]'
		do: [ :condition | 
			self
				assert: ( condition isKindOf: TimeIntervalTriggeringCondition );
				assert: ( condition isSatisfiedOn: self )
			].

	self
		withTriggeringConditionFrom: '[{"type":"time_interval","time_interval":{"start":"22:00","stop":"20:00"}}]'
		do: [ :condition | 
			self
				assert: ( condition isKindOf: TimeIntervalTriggeringCondition );
				deny: ( condition isSatisfiedOn: self )
			]
]

{ #category : #'tests support' }
TriggeringConditionDecoderTest >> timeOfDay [

	^ TimeOfDay hours: 21
]

{ #category : #'tests support' }
TriggeringConditionDecoderTest >> withTriggeringConditionFrom: aString do: aBlock [

	| condition |

	condition := (TriggeringConditionDecoder using: rootSystem)
		decode: (NeoJSONObject fromString: aString).
	aBlock value: condition
]
