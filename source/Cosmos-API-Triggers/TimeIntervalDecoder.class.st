Class {
	#name : #TimeIntervalDecoder,
	#superclass : #Decoder,
	#category : #'Cosmos-API-Triggers'
}

{ #category : #decoding }
TimeIntervalDecoder >> decode: aJSON [

	| start stop |

	start := self startFrom: aJSON.
	stop := self stopFrom: aJSON.

	^ start to: stop
]

{ #category : #'private - decoding' }
TimeIntervalDecoder >> startFrom: aRawTimeInterval [
	
	^ self 
		decode: #start 
		from: aRawTimeInterval 
		using: self timeOfDayDecoder 
]

{ #category : #'private - decoding' }
TimeIntervalDecoder >> stopFrom: aRawTimeInterval [
	
	^ self 
		decode: #stop 
		from: aRawTimeInterval 
		using: self timeOfDayDecoder 
]

{ #category : #'private - decoders' }
TimeIntervalDecoder >> timeOfDayDecoder [

	^ ISO8601TimeOfDayDecoder usingExtendedFormat
]
