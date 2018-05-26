Class {
	#name : #ISO8601DateTimeFormatter,
	#superclass : #Object,
	#instVars : [
		'dateFormatter',
		'timeOfDayFormatter'
	],
	#category : 'Cosmos-API-Core-Formatting'
}

{ #category : #'instance creation' }
ISO8601DateTimeFormatter class >> formatingDateUsing: aDateFormatter andTimeOfDayUsing: aTimeOfDayFormatter [ 
	
	^ self new initializeFormattingDateUsing: aDateFormatter andTimeOfDayUsing: aTimeOfDayFormatter
]

{ #category : #'instance creation' }
ISO8601DateTimeFormatter class >> usingExtendedFormat [

	^ self
		formatingDateUsing: ISO8601DateFormatter usingExtendedFormat
		andTimeOfDayUsing: ISO8601TimeOfDayFormatter usingExtendedFormat
]

{ #category : #'private-formatting' }
ISO8601DateTimeFormatter >> dateAndTimeDelimiter [

	^ $T
]

{ #category : #formatting }
ISO8601DateTimeFormatter >> format: aDateTime [

	| stream |

	stream := WriteStream on: String new.
	self
		putDateOf: aDateTime on: stream;
		putDelimiterOn: stream;
		putTimeOf: aDateTime on: stream;
		putTimeZoneOf: aDateTime on: stream.
	^ stream contents
]

{ #category : #'initialize-release' }
ISO8601DateTimeFormatter >> initializeFormattingDateUsing: aDateFormatter andTimeOfDayUsing: aTimeOfDayFormatter [

	dateFormatter := aDateFormatter.
	timeOfDayFormatter := aTimeOfDayFormatter 
]

{ #category : #'private-formatting' }
ISO8601DateTimeFormatter >> putDateOf: aDateTime on: stream [

	stream nextPutAll: (dateFormatter format: aDateTime date)
]

{ #category : #'private-formatting' }
ISO8601DateTimeFormatter >> putDelimiterOn: stream [

	stream nextPut: self dateAndTimeDelimiter
]

{ #category : #'private-formatting' }
ISO8601DateTimeFormatter >> putTimeOf: aDateTime on: stream [

	stream nextPutAll: (timeOfDayFormatter format: aDateTime timeOfDay)
]

{ #category : #'private-formatting' }
ISO8601DateTimeFormatter >> putTimeZoneOf: aDateTime on: stream [

	aDateTime zone = TimeZones universalTime
		ifTrue: [ stream nextPut: self universalTimeZoneDesignator ]
		ifFalse: [ stream nextPutAll: aDateTime zone offset asString ]
]

{ #category : #'private-formatting' }
ISO8601DateTimeFormatter >> universalTimeZoneDesignator [

	^ $Z
]
