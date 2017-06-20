tests-printing
testPrintOn

	| dataPoint |

	dataPoint := DataPoint on: (January third , 1990) atNoon holding: 10.
	self assert: dataPoint printString equals: 'January 3, 1990 12:00:00 {(GMT-03:00) Local Time}-10'