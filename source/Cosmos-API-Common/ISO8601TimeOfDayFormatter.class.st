Class {
	#name : #ISO8601TimeOfDayFormatter,
	#superclass : #Object,
	#instVars : [
		'separator'
	],
	#category : #'Cosmos-API-Common'
}

{ #category : #'instance creation' }
ISO8601TimeOfDayFormatter class >> configuredToUse: aSeparator [

	^ self new using: aSeparator
]

{ #category : #'instance creation' }
ISO8601TimeOfDayFormatter class >> usingExtendedFormat [

	^ self configuredToUse: $:
]

{ #category : #formatting }
ISO8601TimeOfDayFormatter >> format: aTimeOfDay [

	| stream |

	stream := WriteStream on: String new.
	self
		putHoursOf: aTimeOfDay on: stream;
		putSeparatorOn: stream;
		putMinutesOf: aTimeOfDay on: stream;
		putSeparatorOn: stream;
		putSecondsOf: aTimeOfDay on: stream.
	^ stream contents
]

{ #category : #'initialize-release' }
ISO8601TimeOfDayFormatter >> initialize [

	separator := Optional unusedBecause: 'No se definió un separador'
]

{ #category : #'private-formatting' }
ISO8601TimeOfDayFormatter >> put: aNumber paddedLeftToTwoWithZeroOn: aStream [

	aStream nextPutAll: (aNumber asString padLeftTo: 2 with: $0)
]

{ #category : #'private-formatting' }
ISO8601TimeOfDayFormatter >> putHoursOf: aTimeOfDay on: aStream [ 

	self put: aTimeOfDay hours amount paddedLeftToTwoWithZeroOn: aStream
]

{ #category : #'private-formatting' }
ISO8601TimeOfDayFormatter >> putMinutesOf: aTimeOfDay on: aStream [ 

	self put: aTimeOfDay minutes amount paddedLeftToTwoWithZeroOn: aStream
]

{ #category : #'private-formatting' }
ISO8601TimeOfDayFormatter >> putSecondsOf: aTimeOfDay on: aStream [

	self put: aTimeOfDay seconds amount paddedLeftToTwoWithZeroOn: aStream
]

{ #category : #'private-formatting' }
ISO8601TimeOfDayFormatter >> putSeparatorOn: aStream [

	separator withContentDo: [ :configuredSeparator | aStream nextPut: configuredSeparator ]
]

{ #category : #'initialize-release' }
ISO8601TimeOfDayFormatter >> using: aSeparator [

	separator := Optional containing: aSeparator
]
