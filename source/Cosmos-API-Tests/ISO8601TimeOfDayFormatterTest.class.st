Class {
	#name : #ISO8601TimeOfDayFormatterTest,
	#superclass : #TestCase,
	#category : 'Cosmos-API-Tests-Formatting'
}

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
