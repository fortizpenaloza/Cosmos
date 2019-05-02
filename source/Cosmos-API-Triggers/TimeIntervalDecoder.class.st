Class {
	#name : #TimeIntervalDecoder,
	#superclass : #Decoder,
	#category : #'Cosmos-API-Triggers'
}

{ #category : #decoding }
TimeIntervalDecoder >> decode: aJSON [

	| timeOfDayDecoder |

	timeOfDayDecoder := ISO8601TimeOfDayDecoder usingExtendedFormat.

	^ ((timeOfDayDecoder decode: aJSON start) to: (timeOfDayDecoder decode: aJSON stop))
		asTimeSpan
]
