Class {
	#name : #TimeIntervalDecoder,
	#superclass : #Object,
	#category : #'Cosmos-API-Triggers'
}

{ #category : #decoding }
TimeIntervalDecoder >> decode: aJSON [

	| timeOfDayDecoder |

	timeOfDayDecoder := ISO8601TimeOfDayDecoder usingExtendedFormat.

	^ (timeOfDayDecoder decode: aJSON start) to: (timeOfDayDecoder decode: aJSON stop)
]
