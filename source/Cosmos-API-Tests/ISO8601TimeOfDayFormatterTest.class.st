Class {
	#name : #ISO8601TimeOfDayFormatterTest,
	#superclass : #TestCase,
	#category : 'Cosmos-API-Tests-Formatting'
}

{ #category : #history }
ISO8601TimeOfDayFormatterTest class >> lastStoredRun [
	^ ((Dictionary new) add: (#timeStamp->(DateAndTime basicNew instVarAt: 1 put: 6510; instVarAt: 2 put: (Duration seconds: -10800 nanoSeconds: 0); instVarAt: 3 put: 2458339; instVarAt: 4 put: 646163000; yourself)); add: (#passed->((Set new) add: #testFormattingUsingExtendedFormat; yourself)); add: (#failures->((Set new))); add: (#errors->((Set new))); yourself)
]

{ #category : #tests }
ISO8601TimeOfDayFormatterTest >> testFormattingUsingExtendedFormat [

	self
		assert: (ISO8601TimeOfDayFormatter usingExtendedFormat format: TimeOfDay firstTimeOfDay)
		equals: '00:00:00'.
	self
		assert:
			(ISO8601TimeOfDayFormatter usingExtendedFormat
				format:
					(TimeOfDay
						hours: 6
						minutes: 7
						seconds: 8
						milliseconds: 80))
		equals: '06:07:08'
]
