Class {
	#name : #TriggeringConditionDecoder,
	#superclass : #Object,
	#instVars : [
		'cosmos'
	],
	#category : #'Cosmos-API-Triggers'
}

{ #category : #'instance creation' }
TriggeringConditionDecoder class >> using: aCosmosSystem [
	
	^ self new initializeUsing: aCosmosSystem 
]

{ #category : #'private - decoders' }
TriggeringConditionDecoder >> conditionDecoder [
	
	^ ConditionDecoder new
]

{ #category : #'private - decoding' }
TriggeringConditionDecoder >> conditionFrom: aDictionary [

	^ self
		decode: #condition
		from: aDictionary
		using: self conditionDecoder
]

{ #category : #'private - decoders' }
TriggeringConditionDecoder >> dataStreamDecoder [

	^ WellKnownObjectDecoder
		querying: cosmos >> #DataStreamManagementSystemInterface
		sending: #streamNamed:
]

{ #category : #'private - decoding' }
TriggeringConditionDecoder >> dataStreamFrom: rawTriggeringCondition [

	^ self
		decode: #data_stream
		from: rawTriggeringCondition
		using: self dataStreamDecoder
]

{ #category : #decoding }
TriggeringConditionDecoder >> decode: aRaw [

	| decoderByType |

	decoderByType := Dictionary new
		at: #data_stream_current_value
			put: [ :rawTriggeringCondition | 
			DataStreamCurrentValueTriggeringCondition
				of: (self dataStreamFrom: rawTriggeringCondition)
				comparingWith: (self conditionFrom: rawTriggeringCondition) ];
		yourself.

	aRaw
		collect: [ :rawTriggeringCondition | 
			(decoderByType at: (rawTriggeringCondition at: #type))
				value: rawTriggeringCondition ]
]

{ #category : #'private - decoding' }
TriggeringConditionDecoder >> decode: aKey from: aDictionary using: aDecoder [

	^ self
		decode: aKey
		from: aDictionary
		using: aDecoder
		ifAbsent: [ KeyNotFound signal: ('<1s> is mandatory and must be present' expandMacrosWith: aKey) ]
]

{ #category : #'private - decoding' }
TriggeringConditionDecoder >> decode: aKey from: aDictionary using: aDecoder ifAbsent: aBlock [

	^ aDictionary
		at: aKey
		ifPresent: [ :rawData | aDecoder decode: rawData ]
		ifAbsent: aBlock
]

{ #category : #initialization }
TriggeringConditionDecoder >> initializeUsing: aCosmosSystem [

	cosmos := aCosmosSystem 
]
