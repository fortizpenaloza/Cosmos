Class {
	#name : #ISO8601TimeOfDayDecoder,
	#superclass : #Object,
	#instVars : [
		'separator',
		'messageByArgumentAmount'
	],
	#category : #'Cosmos-API-Common'
}

{ #category : #'private - instance creation' }
ISO8601TimeOfDayDecoder class >> configuredToUse: anOptionalSeparator [
	
	^ self new initializeConfigureToUse: anOptionalSeparator 
	
]

{ #category : #'instance creation' }
ISO8601TimeOfDayDecoder class >> usingBasicFormat [

	^ self configuredToUse: Optional unused
]

{ #category : #'instance creation' }
ISO8601TimeOfDayDecoder class >> usingExtendedFormat [

	^ self configuredToUse: (Optional containing: $:)
]

{ #category : #'private - decoding' }
ISO8601TimeOfDayDecoder >> addMillisecondsPartFrom: rawParts on: parts [

	rawParts size > 1
		ifTrue: [ parts add: rawParts last ]
]

{ #category : #'private - decoding' }
ISO8601TimeOfDayDecoder >> addTimePartsFrom: rawParts on: parts [

	parts addAll: (self timePartsFrom: rawParts)
]

{ #category : #decoding }
ISO8601TimeOfDayDecoder >> decode: aString [

	| parts |

	parts := OrderedCollection new.

	separator
		withContentDo: [ :configuredSeparator | 
			parts
				addAll:
					(aString
						substrings:
							{configuredSeparator.
							self millisecondsSeparator}) ]
		ifUnused: [ | rawParts |

			rawParts := aString substrings: {self millisecondsSeparator}.

			self addTimePartsFrom: rawParts on: parts.
			self addMillisecondsPartFrom: rawParts on: parts ].

	^ TimeOfDay
		perform: (messageByArgumentAmount at: parts size)
		withArguments: (parts asArray collect: #asNumber)
]

{ #category : #initialization }
ISO8601TimeOfDayDecoder >> initializeConfigureToUse: anOptionalSeparator [

	separator := anOptionalSeparator.

	messageByArgumentAmount := Dictionary new
		at: 1 put: #hours:;
		at: 2 put: #hours:minutes:;
		at: 3 put: #hours:minutes:seconds:;
		at: 4 put: #hours:minutes:seconds:milliseconds:;
		yourself
]

{ #category : #'private - accessing' }
ISO8601TimeOfDayDecoder >> millisecondsSeparator [

	^ $.
]

{ #category : #'private - decoding' }
ISO8601TimeOfDayDecoder >> timePartsFrom: rawParts [

	^ rawParts first
		groupsOf: 2
		atATimeCollect: [ :first :second | first asString , second asString ]
]
