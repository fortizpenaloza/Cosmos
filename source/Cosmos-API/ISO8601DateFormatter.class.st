Class {
	#name : #ISO8601DateFormatter,
	#superclass : #Object,
	#instVars : [
		'separator'
	],
	#category : #'Cosmos-API-Formatting'
}

{ #category : #'instance creation' }
ISO8601DateFormatter class >> configuredToUse: aSeparator [

	^ self new using: aSeparator
]

{ #category : #'instance creation' }
ISO8601DateFormatter class >> usingBasicFormat [

	^ self new
]

{ #category : #'instance creation' }
ISO8601DateFormatter class >> usingExtendedFormat [

	^ self configuredToUse: $-
]

{ #category : #formatting }
ISO8601DateFormatter >> format: aDate [

	| stream |

	stream := WriteStream on: String new.
	self
		putYearOf: aDate on: stream;
		putSeparatorOn: stream;
		putMonthOf: aDate on: stream;
		putSeparatorOn: stream;
		putDayOf: aDate on: stream.
	^ stream contents
]

{ #category : #'initialize-release' }
ISO8601DateFormatter >> initialize [

	separator := Optional unusedBecause: 'No se definió un separador'
]

{ #category : #'private-formatting' }
ISO8601DateFormatter >> put: aNumber paddedLeftToTwoWithZeroOn: aStream [

	aStream nextPutAll: (aNumber asString padLeftTo: 2 with: $0)
]

{ #category : #'private-formatting' }
ISO8601DateFormatter >> putDayOf: aDate on: aStream [

	self put: aDate dayNumber paddedLeftToTwoWithZeroOn: aStream
]

{ #category : #'private-formatting' }
ISO8601DateFormatter >> putMonthOf: aDate on: aStream [

	self put: aDate monthNumber paddedLeftToTwoWithZeroOn: aStream
]

{ #category : #'private-formatting' }
ISO8601DateFormatter >> putSeparatorOn: aStream [

	separator withContentDo: [ :configuredSeparator | aStream nextPut: configuredSeparator ]
]

{ #category : #'private-formatting' }
ISO8601DateFormatter >> putYearOf: aDate on: aStream [

	aStream nextPutAll: aDate yearNumber asString
]

{ #category : #'initialize-release' }
ISO8601DateFormatter >> using: aSeparator [

	separator := Optional containing: aSeparator
]
