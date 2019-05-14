Class {
	#name : #ActionTriggerDecoder,
	#superclass : #Decoder,
	#instVars : [
		'cosmos'
	],
	#category : #'Cosmos-API-Triggers'
}

{ #category : #'instance creation' }
ActionTriggerDecoder class >> using: aCosmosSystem [
	
	^ self new initializeUsing: aCosmosSystem 
]

{ #category : #'private - decoders' }
ActionTriggerDecoder >> actionDecoder [

	^ WellKnownObjectDecoder
		querying: cosmos >> #ActionManagementSystemInterface
		sending: #actionNamed:
]

{ #category : #'private - decoding' }
ActionTriggerDecoder >> actionFrom: aRawTrigger [

	^ self 
		decode: #action 
		from: aRawTrigger 
		using: self actionDecoder
]

{ #category : #decoding }
ActionTriggerDecoder >> decode: aRawTrigger [

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

{ #category : #'instance creation' }
ActionTriggerDecoder >> initializeUsing: aCosmosSystem [
	
	cosmos := aCosmosSystem
]

{ #category : #'private - decoders' }
ActionTriggerDecoder >> triggeringConditionDecoder [

	^ TriggeringConditionDecoder using: cosmos
]

{ #category : #'private - decoding' }
ActionTriggerDecoder >> triggeringConditionFrom: aRawTrigger [

	^ self
		decode: #conditions
		from: aRawTrigger
		using: self triggeringConditionDecoder
]

{ #category : #'private - decoders' }
ActionTriggerDecoder >> triggeringPolicyDecoder [

	^ TriggeringPolicyDecoder using: cosmos 
]

{ #category : #'private - decoding' }
ActionTriggerDecoder >> triggeringPolicyFrom: aDictionary [ 
	
	^ self 
		decode: #policy 
		from: aDictionary 
		using: self triggeringPolicyDecoder
]
