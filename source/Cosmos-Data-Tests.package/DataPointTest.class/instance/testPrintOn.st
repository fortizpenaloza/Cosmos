tests
testPrintOn

	| dataPoint |

	dataPoint := DataPoint on: (January third , 1990) atNoon holding: 10.
	self assert: dataPoint printString equals: ('<1p>-<2p>' expandMacrosWith: dataPoint timestamp with: dataPoint value)