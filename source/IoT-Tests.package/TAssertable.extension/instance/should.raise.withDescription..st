*IoT-Tests
should: aBlock raise: anException withDescription: aDescription

	^ self
		should: aBlock
		raise: anException
		withExceptionDo: [ :signal | self assert: signal messageText equals: aDescription ]