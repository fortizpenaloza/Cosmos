Class {
	#name : #ISO8601DateTimeFormatterTest,
	#superclass : #TestCase,
	#category : 'Cosmos-API-Tests-Formatting'
}

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
		assert: (ISO8601DateTimeFormatter usingExtendedFormat format: (September sixth , 2015) atNoon)
		equals: '2015-09-06T12:00:00' , TimeZones local offset asString

]

{ #category : #tests }
ISO8601DateTimeFormatterTest >> testUTCFormattingUsingExtendedFormat [

	self
		assert:
			(ISO8601DateTimeFormatter usingExtendedFormat
				format: self septemberSixthAtNoonUTC)
		equals: '2015-09-06T12:00:00Z'
]
