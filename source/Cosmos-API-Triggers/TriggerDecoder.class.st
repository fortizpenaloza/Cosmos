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

	^ WellKnownObjectDecoder
		querying: #ActionManagementSystemInterface
		on: cosmos
		sending: #actionNamed:
]

{ #category : #'private - decoding' }
TriggerDecoder >> actionFrom: aRawTrigger [

	^ self 
		decode: #action 
		from: aRawTrigger 
		using: self actionDecoder
]

{ #category : #'private - decoders' }
TriggerDecoder >> dataStreamDecoder [

	^ WellKnownObjectDecoder
		querying: #DataStreamManagementSystemInterface
		on: cosmos
		sending: #streamNamed:
]

{ #category : #'private - decoding' }
TriggerDecoder >> dataStreamFrom: aDictionary [

	^ self
		decode: #data_stream
		from: aDictionary
		using: self dataStreamDecoder
]

{ #category : #decoding }
TriggerDecoder >> decode: aRawTrigger [

	| action triggeringPolicy triggeringCondition |

	action := self actionFrom: aRawTrigger.
	triggeringPolicy := self triggeringPolicyFrom: aRawTrigger.
	triggeringCondition := self triggeringConditionFrom: aRawTrigger.

	^ ActionTrigger
		named: (aRawTrigger at: #name)
		triggering: action
		accordingTo: triggeringPolicy
		ifSatisfies: triggeringCondition
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
		ifPresent: [ :rawData | aDecoder decode: rawData ]
		ifAbsent: aBlock
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

{ #category : #'instance creation' }
TriggerDecoder >> initializeUsing: aCosmosSystem [
	
	cosmos := aCosmosSystem
]

{ #category : #'private - decoders' }
TriggerDecoder >> timeIntervalDecoder [

	^ [ :string | TimeUnits minute with: 5 ]
]

{ #category : #'private - decoders' }
TriggerDecoder >> triggeringConditionDecoder [
	
	
	^ TriggeringConditionDecoder new
]

{ #category : #'private - decoding' }
TriggerDecoder >> triggeringConditionFrom: aRawTrigger [

	^ self
		decode: #conditions
		from: aRawTrigger
		using: self triggeringConditionDecoder
]

{ #category : #'private - decoders' }
TriggerDecoder >> triggeringPolicyDecoder [

	^ TriggeringPolicyDecoder using: cosmos 
]

{ #category : #'private - decoding' }
TriggerDecoder >> triggeringPolicyFrom: aDictionary [ 
	
	^ self 
		decode: #policy 
		from: aDictionary 
		using: self triggeringPolicyDecoder
]
