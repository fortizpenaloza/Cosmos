Class {
	#name : #TriggerDecoderTest,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'Cosmos-API-Triggers-Tests'
}

{ #category : #running }
TriggerDecoderTest >> setUp [

	super setUp.

	(SensorsSampleAddOn on: rootSystem) install.

	self actionManagementSystem
		register:
			(Action named: 'Set triggered to true' evaluating: [ "Do nothing" ])
]

{ #category : #'private - running' }
TriggerDecoderTest >> setUpRequirements [

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
TriggerDecoderTest >> systemDateTime [

	^ DateTime
		date: October first , 2014
		timeOfDay: TimeOfDay noon
		zone: TimeZones buenosAires
]

{ #category : #running }
TriggerDecoderTest >> testDecodingTrigger [

	self
		withTriggerFrom:
			'{"name":"Always set triggered to true","action":"Set triggered to true","policy":{"type":"data_point_registration","data_stream":"Temperature"},"conditions": [{"type":"data_stream_current_value","data_stream":"Temperature","condition":{"operator":">","value":54}}]}' 
		do: [ :trigger | 
			self
				assert: trigger name equals: 'Always set triggered to true';
				assert:
					(trigger triggeringPolicy
						isKindOf: DataPointRegistrationTriggeringPolicy) ]
]

{ #category : #running }
TriggerDecoderTest >> testDecodingTriggerFailsIfActionNotFound [

	| decoder |

	decoder := TriggerDecoder using: rootSystem.
	self
		should: [ decoder
				decode:
					(NeoJSONReader
						fromString:
							'{
    "name": "Always set triggered to true",
    "action": "Bleh",
    "policy": {
        "type": "data_point_registration",
        "data_stream": "Temperature"
    },
    "conditions": []
}') ]
		raise: InstanceCreationFailed
		withMessageText: 'Action named ''Bleh'' not found'
]

{ #category : #running }
TriggerDecoderTest >> testDecodingTriggerFailsIfDataStreamOnPolicyNotFound [

	| decoder |

	decoder := TriggerDecoder using: rootSystem.
	self
		should: [ decoder
				decode:
					(NeoJSONReader
						fromString:
							'{
    "name": "Always set triggered to true",
    "action": "Set triggered to true",
    "policy": {
        "type": "data_point_registration",
        "data_stream": "pH"
    },
    "conditions": []
}') ]
		raise: InstanceCreationFailed
		withMessageText: 'Data stream named ''pH'' not found'
]

{ #category : #running }
TriggerDecoderTest >> testDecodingTriggerFailsIfKeyIsMissing [

	| decoder |

	decoder := TriggerDecoder using: rootSystem.
	self
		should: [ decoder
				decode:
					(NeoJSONReader
						fromString:
							'{
        "name":"Set triggered to true after a data point greater than 11 was registered on Temperature if current time is between 8PM and 9PM",
        "action":"Set triggered to true",
        "policy":{"type":"data_point_registration","data_stream":"Temperature"},
        "conditions":[
                        {
                            "type":"data_stream_current_value",
                            "data_stream":"Temperature",
                            "condition":{"operator":">","value":11}
                        },
                        {
                            "type":"time_interval",
                            "from":"20:00:00",
                            "to":"21:00:00"
                        }
                    ]
    }
') ]
		raise: KeyNotFound 
		withMessageText: 'time_interval is mandatory and must be present'
]

{ #category : #running }
TriggerDecoderTest >> testDecodingTriggerWithIntervalWithoutSeconds [

	self
		withTriggerFrom: '{"name":"Set triggered to true after a data point greater than 11 was registered on Temperature if current time is between 4:14PM and 4:18PM","action":"Set triggered to true","policy":{"type":"data_point_registration","data_stream":"Temperature"},"conditions":[{"type":"time_interval","time_interval":{"start":"16:14","stop":"16:18"}}]}'
		do: [ :trigger | 
			self
				assert: trigger name equals: 'Set triggered to true after a data point greater than 11 was registered on Temperature if current time is between 4:14PM and 4:18PM';
				assert:
					(trigger triggeringPolicy
						isKindOf: DataPointRegistrationTriggeringPolicy) ]
]

{ #category : #'tests support' }
TriggerDecoderTest >> withTriggerFrom: aString do: aBlock [

	| decoder trigger |

	decoder := TriggerDecoder using: rootSystem.
	trigger := decoder decode: (NeoJSONObject fromString: aString).

	aBlock value: trigger
]
