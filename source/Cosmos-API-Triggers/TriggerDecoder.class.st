Class {
	#name : #TriggerDecoder,
	#superclass : #Object,
	#instVars : [
		'cosmos'
	],
	#category : #'Cosmos-API-Triggers'
}

{ #category : #'instance creation' }
TriggerDecoder class >> using: aCosmosSystem [
	
	^ self new initializeUsing: aCosmosSystem 
]

{ #category : #'private - decoders' }
TriggerDecoder >> actionDecoder [

	^ [ :name | 
	(cosmos systemImplementing: #ActionManagementSystemInterface)
		actionNamed: name
		ifFound: [ :action | action ]
		ifNone: [ ObjectNotFound signal: ('Action named <1s> not found' expandMacrosWith: name) ] ]
]

{ #category : #'private - decoders' }
TriggerDecoder >> dataStreamDecoder [

	^ [ :name | 
	(cosmos systemImplementing: #DataManagementSystemInterface)
		streamNamed: name
		ifFound: [ :stream | stream ]
		ifNone: [ ObjectNotFound  signal: ('Data stream named <1s> not found' expandMacrosWith: name) ] ]
]

{ #category : #decoding }
TriggerDecoder >> decode: aRawTrigger [

	^ ActionTrigger
		named: (aRawTrigger at: #name)
		triggering: (self decodeActionFrom: aRawTrigger)
		accordingTo: (self decodeTriggeringPolicyFrom: aRawTrigger)
		ifSatisfies: (self decodeTriggeringConditionFrom: aRawTrigger)
]

{ #category : #'private - decoding' }
TriggerDecoder >> decode: aKey from: aDictionary using: aDecoder [

	^ self
		decode: aKey
		from: aDictionary
		using: aDecoder
		ifAbsent: [ KeyNotFound signal: ('<1s> is mandatory and must be present' expandMacrosWith: aKey) ]
]

{ #category : #'private - decoding' }
TriggerDecoder >> decode: aKey from: aDictionary using: aDecoder ifAbsent: aBlock [

	^ aDictionary
		at: aKey
		ifPresent: [ :rawData | aDecoder value: rawData ]
		ifAbsent: aBlock
]

{ #category : #'private - decoding' }
TriggerDecoder >> decodeActionFrom: aRawTrigger [

	^ self 
		decode: #action 
		from: aRawTrigger 
		using: self actionDecoder
]

{ #category : #'private - decoding' }
TriggerDecoder >> decodeDataStreamFrom: aDictionary [

	^ self
		decode: #data_stream
		from: aDictionary
		using: self dataStreamDecoder
]

{ #category : #'private - decoding' }
TriggerDecoder >> decodeTimeIntervalFrom: aDictionary [

	^ self
		decode: #time_interval
		from: aDictionary
		using: self timeIntervalDecoder
]

{ #category : #'private - decoding' }
TriggerDecoder >> decodeTriggeringConditionFrom: aDictionary [

	^ AlwaysTriggeringCondition new
]

{ #category : #'private - decoding' }
TriggerDecoder >> decodeTriggeringPolicyFrom: aDictionary [ 
	
	^ self 
		decode: #policy 
		from: aDictionary 
		using: self triggeringPolicyDecoder
]

{ #category : #'instance creation' }
TriggerDecoder >> initializeUsing: aCosmosSystem [
	
	cosmos := aCosmosSystem
]

{ #category : #'private - decoders' }
TriggerDecoder >> timeIntervalDecoder [

	^ [ :string | TimeUnits minute with: 5 ]
]

{ #category : #'private - decoders' }
TriggerDecoder >> triggeringPolicyDecoder [

	^ [ :rawTriggeringPolicy | | decoderByType |

	decoderByType := Dictionary new
		at: #periodical
			put: [ PeriodicalTriggeringPolicy every: (self decodeTimeIntervalFrom: rawTriggeringPolicy) ];
		at: #data_point_registration
			put: [ DataPointRegistrationTriggeringPolicy
				on: (self decodeDataStreamFrom: rawTriggeringPolicy) ];
		yourself.

	(decoderByType at: (rawTriggeringPolicy at: #type)) value ]
]
