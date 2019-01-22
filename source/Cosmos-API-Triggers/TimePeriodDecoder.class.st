Class {
	#name : #TimePeriodDecoder,
	#superclass : #Object,
	#category : #'Cosmos-API-Triggers'
}

{ #category : #decoding }
TimePeriodDecoder >> decode: aString [

	| rawTimeInterval units |

	self flag: 'fix this'.
	rawTimeInterval := aString substrings.
	rawTimeInterval size ~= 2
		ifTrue: [ Error signal: 'No lo defini' ].

	units := {('second' -> TimeUnits second).
	('seconds' -> TimeUnits second).
	('minute' -> TimeUnits minute).
	('minutes' -> TimeUnits minute).
	('hour' -> TimeUnits hour).
	('hours' -> TimeUnits hour)} asDictionary.

	^ (units at: rawTimeInterval second)
		with: rawTimeInterval first asInteger
]
