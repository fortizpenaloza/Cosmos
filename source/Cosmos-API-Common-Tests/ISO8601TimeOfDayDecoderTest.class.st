"
An ISO8601TimeOfDayDecoderTest is a test class for testing the behavior of ISO8601TimeOfDayDecoder
"
Class {
	#name : #ISO8601TimeOfDayDecoderTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Common-Tests'
}

{ #category : #tests }
ISO8601TimeOfDayDecoderTest >> testDecodingUsingBasicFormat [

	| decoder |

	decoder := ISO8601TimeOfDayDecoder usingBasicFormat.

	self
		assert: (decoder decode: '000000')
		equals: TimeOfDay firstTimeOfDay.

	self
		assert: (decoder decode: '060708.080')
		equals:
			(TimeOfDay
				hours: 6
				minutes: 7
				seconds: 8
				milliseconds: 80).

	self
		assert: (decoder decode: '060708')
		equals: (TimeOfDay hours: 6 minutes: 7 seconds: 8).

	self
		assert: (decoder decode: '0607')
		equals: (TimeOfDay hours: 6 minutes: 7).

	self assert: (decoder decode: '06') equals: (TimeOfDay hours: 6)
]

{ #category : #tests }
ISO8601TimeOfDayDecoderTest >> testDecodingUsingExtendedFormat [

	| decoder |

	decoder := ISO8601TimeOfDayDecoder usingExtendedFormat.

	self
		assert: (decoder decode: '00:00:00')
		equals: TimeOfDay firstTimeOfDay.

	self
		assert: (decoder decode: '06:07:08.080')
		equals:
			(TimeOfDay
				hours: 6
				minutes: 7
				seconds: 8
				milliseconds: 80).

	self
		assert: (decoder decode: '06:07:08')
		equals: (TimeOfDay hours: 6 minutes: 7 seconds: 8).

	self
		assert: (decoder decode: '06:07')
		equals: (TimeOfDay hours: 6 minutes: 7).

	self assert: (decoder decode: '06') equals: (TimeOfDay hours: 6)
]
