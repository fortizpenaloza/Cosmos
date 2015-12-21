test
testOnCreationDataPointsIsEmpty

	| dataStream |
	
	dataStream := DataStream identifiedBy: 'temp'.
	self assert: dataStream dataPoints isEmpty