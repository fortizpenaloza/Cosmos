private-formatting
putTimeZoneOf: aDateTime on: stream

	aDateTime zone = TimeZones universalTime
		ifTrue: [ stream nextPut: self universalTimeZoneDesignator ]
		ifFalse: [ stream nextPutAll: aDateTime zone offset asString ]