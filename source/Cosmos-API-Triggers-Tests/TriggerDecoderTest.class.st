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
		registerSubsystem: ActionManagementSystem new;
		registerSubsystem: TriggerManagementSystem new
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

	| decoder trigger |

	decoder := TriggerDecoder using: rootSystem.
	trigger := decoder
		decode:
			(NeoJSONReader
				fromString:
					'{
    "name": "Always set triggered to true",
    "action": "Set triggered to true",
    "policy": {
        "type": "data_point_registration",
        "data_stream": "Temperature"
    },
    "conditions": [
        {
            "type": "data_stream_current_value",
            "data_stream": "Temperature",
            "condition": {
                "operator": ">",
                "value": 54
            }
        }
    ]
}').

	self
		assert: trigger name equals: 'Always set triggered to true';
		assert:
			(trigger triggeringPolicy
				isKindOf: DataPointRegistrationTriggeringPolicy)
]

{ #category : #running }
TriggerDecoderTest >> testDecodingTriggerFailsIfActionNotFound [

	| decoder  |

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

	| decoder  |

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
