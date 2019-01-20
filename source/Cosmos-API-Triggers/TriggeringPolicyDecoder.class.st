Class {
	#name : #TriggeringPolicyDecoder,
	#superclass : #Object,
	#category : #'Cosmos-API-Triggers'
}

{ #category : #'private - decoders' }
TriggeringPolicyDecoder >> dataStreamDecoder [
	self shouldBeImplemented.
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
