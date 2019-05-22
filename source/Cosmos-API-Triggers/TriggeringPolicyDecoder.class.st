Class {
	#name : #TriggeringPolicyDecoder,
	#superclass : #Decoder,
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
TriggeringPolicyDecoder >> decode: aRawTriggeringPolicy [

	| decoderByType |

	decoderByType := Dictionary new
		at: #periodical
			put: [ :rawTriggeringPolicy | 
			PeriodicalTriggeringPolicy
				every: (self timePeriodFrom: rawTriggeringPolicy) ];
		at: #data_point_registration
			put: [ :rawTriggeringPolicy | 
			DataPointRegistrationTriggeringPolicy
				on: (self dataStreamFrom: rawTriggeringPolicy) ];
		yourself.

	^ (decoderByType at: (aRawTriggeringPolicy at: #type))
		value: aRawTriggeringPolicy
]

{ #category : #initialization }
TriggeringPolicyDecoder >> initializeUsing: aCosmosSystem [
	
	cosmos := aCosmosSystem 
]

{ #category : #'private - decoders' }
TriggeringPolicyDecoder >> timePeriodDecoder [

	^ TimePeriodDecoder new 
]

{ #category : #'private - decoding' }
TriggeringPolicyDecoder >> timePeriodFrom: aDictionary [

	^ self
		decode: #time_interval
		from: aDictionary
		using: self timePeriodDecoder
]
