tests
testValue

	| dataPoint |

	dataPoint := DataPoint on: (January third , 1990) atNoon holding: 10.
	self assert: dataPoint value equals: 10