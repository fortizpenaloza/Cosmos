tests
testTimestamp

	| dataPoint |

	dataPoint := DataPoint on: (January third , 1990) atNoon holding: 10.
	self assert: dataPoint timestamp equals: (January third , 1990) atNoon