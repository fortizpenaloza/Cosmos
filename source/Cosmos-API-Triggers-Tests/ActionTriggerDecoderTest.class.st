Class {
	#name : #ActionTriggerDecoderTest,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'Cosmos-API-Triggers-Tests'
}

{ #category : #running }
ActionTriggerDecoderTest >> setUp [

	super setUp.

	(SensorsSampleAddOn on: rootSystem) install.

	self actionManagementSystem
		register:
			(Action named: 'Set triggered to true' evaluating: [ "Do nothing" ])
]

{ #category : #'private - running' }
ActionTriggerDecoderTest >> setUpRequirements [

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
ActionTriggerDecoderTest >> systemDateTime [

	^ DateTime
		date: October first , 2014
		timeOfDay: TimeOfDay noon
		zone: TimeZones buenosAires
]

{ #category : #tests }
ActionTriggerDecoderTest >> testDecodingArithmeticConditionIsEqualsToNil [

	self
		withTriggerFrom: '{
    "name": "Set triggered to true when temperature is higher than 24 and humidity higher than nil",
    "action": "Set triggered to true",
    "policy": {
        "type": "data_point_registration",
        "data_stream": "Humidity"
    },
    "conditions": [
        {
            "type": "data_stream_current_value",
            "data_stream": "Humidity",
            "condition": {
                "operator": "=",
                "value": null
            }
        },
        {
            "type": "data_stream_current_value",
            "data_stream": "Temperature",
            "condition": {
                "operator": ">",
                "value": 24
            }
        }
    ]
}'
		do: [ :trigger | 
			self
				assert: trigger name equals: 'Set triggered to true when temperature is higher than 24 and humidity higher than nil';
				assert:
					(trigger triggeringPolicy
						isKindOf: DataPointRegistrationTriggeringPolicy) ]
]

{ #category : #tests }
ActionTriggerDecoderTest >> testDecodingOpenRoofDuringAnInterval [

	self
		withTriggerFrom: '{"name":"CloseRoofBetweenHours","action":"Set triggered to true","policy":{"type":"periodical","time_interval":"1 seconds"},"conditions":[{"type":"time_interval","time_interval":{"start":"22:00:01","stop":"20:59:59"}}]}'
		do: [ :trigger | 
			self
				assert: trigger name equals: 'CloseRoofBetweenHours';
				assert:
					(trigger triggeringPolicy
						isKindOf: PeriodicalTriggeringPolicy) ]
]

{ #category : #tests }
ActionTriggerDecoderTest >> testDecodingOpenRoofDuringAnIntervalIfNotRaining [

	self
		withTriggerFrom: '{"name":"OpenRoofBetweenHoursIfNotRaining","action":"Set triggered to true","policy":{"type":"periodical","time_interval":"5 minutes"},"conditions":[{"type":"time_interval","time_interval":{"start":"21:00:00","stop":"22:00:00"}},{"type":"data_stream_current_value","data_stream":"Temperature","condition":{"operator":"=","value":"0"}}]}'
		do: [ :trigger | 
			self
				assert: trigger name equals: 'OpenRoofBetweenHoursIfNotRaining';
				assert:
					(trigger triggeringPolicy
						isKindOf: PeriodicalTriggeringPolicy) ]
]

{ #category : #tests }
ActionTriggerDecoderTest >> testDecodingPeriodicalActionTrigger [

	self
		withTriggerFrom: '{"name":"CloseRoofOnlyIfRaining","action":"Set triggered to true","policy":{"type":"periodical","time_interval":"1 seconds"},"conditions":[{"type":"data_stream_current_value","data_stream":"Temperature","condition":{"operator":"=","value":"1"}}]}
'
		do: [ :trigger | 
			self
				assert: trigger name equals: 'CloseRoofOnlyIfRaining';
				assert:
					(trigger triggeringPolicy
						isKindOf: PeriodicalTriggeringPolicy) ]
]

{ #category : #tests }
ActionTriggerDecoderTest >> testDecodingTrigger [

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

{ #category : #tests }
ActionTriggerDecoderTest >> testDecodingTriggerFailsIfActionNotFound [

	| decoder |

	decoder := ActionTriggerDecoder using: rootSystem.
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

{ #category : #tests }
ActionTriggerDecoderTest >> testDecodingTriggerFailsIfDataStreamOnPolicyNotFound [

	| decoder |

	decoder := ActionTriggerDecoder using: rootSystem.
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

{ #category : #tests }
ActionTriggerDecoderTest >> testDecodingTriggerFailsIfKeyIsMissing [

	| decoder |

	decoder := ActionTriggerDecoder using: rootSystem.
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

{ #category : #tests }
ActionTriggerDecoderTest >> testDecodingTriggerWithIntervalWithoutSeconds [

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
ActionTriggerDecoderTest >> withTriggerFrom: aString do: aBlock [

	| trigger |

	trigger := (ActionTriggerDecoder using: rootSystem)
		decode: (NeoJSONObject fromString: aString).

	aBlock value: trigger
]
