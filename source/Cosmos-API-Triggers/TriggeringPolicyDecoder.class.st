Class {
	#name : #TriggeringPolicyDecoder,
	#superclass : #Object,
	#instVars : [
		'cosmos'
	],
	#category : #'Cosmos-API-Triggers'
}

{ #category : #'instance creation' }
TriggeringPolicyDecoder class >> using: aCosmosSystem [
	
	^ self new initializeUsing: aCosmosSystem 
]

{ #category : #'private - decoders' }
TriggeringPolicyDecoder >> dataStreamDecoder [

	^ WellKnownObjectDecoder
		querying: cosmos >> #DataStreamManagementSystemInterface
		sending: #streamNamed:
]

{ #category : #decoding }
TriggeringPolicyDecoder >> dataStreamFrom: aDictionary [

	^ self
		decode: #data_stream
		from: aDictionary
		using: self dataStreamDecoder
]

{ #category : #decoding }
TriggeringPolicyDecoder >> decode: aCollection [ 
	
	^ [ :rawTriggeringPolicy | 
	| decoderByType |

	decoderByType := Dictionary new
		at: #periodical
			put: [ PeriodicalTriggeringPolicy
				every: (self decodeTimeIntervalFrom: rawTriggeringPolicy) ];
		at: #data_point_registration
			put: [ DataPointRegistrationTriggeringPolicy
				on: (self dataStreamFrom: rawTriggeringPolicy) ];
		yourself.

	(decoderByType at: (rawTriggeringPolicy at: #type)) value ] value: aCollection 
]

{ #category : #'private - decoding' }
TriggeringPolicyDecoder >> decode: aKey from: aDictionary using: aDecoder [

	^ self
		decode: aKey
		from: aDictionary
		using: aDecoder
		ifAbsent: [ KeyNotFound signal: ('<1s> is mandatory and must be present' expandMacrosWith: aKey) ]
]

{ #category : #'private - decoding' }
TriggeringPolicyDecoder >> decode: aKey from: aDictionary using: aDecoder ifAbsent: aBlock [

	^ aDictionary
		at: aKey
		ifPresent: [ :rawData | aDecoder decode: rawData ]
		ifAbsent: aBlock
]

{ #category : #initialization }
TriggeringPolicyDecoder >> initializeUsing: aCosmosSystem [
	
	cosmos := aCosmosSystem 
]
