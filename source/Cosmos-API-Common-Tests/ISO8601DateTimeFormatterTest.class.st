Class {
	#name : #ISO8601DateTimeFormatterTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Common-Tests-Formatting'
}

{ #category : #accessing }
ISO8601DateTimeFormatterTest >> septemberSixthAtNoonBuenosAires [

	^ DateTime
		date: September sixth , 2015
		timeOfDay: TimeOfDay noon
		zone: TimeZones buenosAires
]

{ #category : #accessing }
ISO8601DateTimeFormatterTest >> septemberSixthAtNoonUTC [

	^ DateTime
		date: September sixth , 2015
		timeOfDay: TimeOfDay noon
		zone: TimeZones universalTime
]

{ #category : #tests }
ISO8601DateTimeFormatterTest >> testLocalTimeFormattingUsingExtendedFormat [

	self
		assert: (ISO8601DateTimeFormatter usingExtendedFormat format: self septemberSixthAtNoonBuenosAires)
		equals: '2015-09-06T12:00:00-03:00'
]

{ #category : #tests }
ISO8601DateTimeFormatterTest >> testUTCFormattingUsingExtendedFormat [

	self
		assert:
			(ISO8601DateTimeFormatter usingExtendedFormat
				format: self septemberSixthAtNoonUTC)
		equals: '2015-09-06T12:00:00Z'
]
