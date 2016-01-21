tests
testAddingDataPoint

	| dataStream |

	dataStream := DataStream named: 'Temperature' createdOn: (October first , 2015) atMidnight belongingTo: self dataChannel.
	self assert: dataStream dataPoints isEmpty.
	
	dataStream add: (DataPoint on: self septemberSixthOf2015AtNoon holding: 10).
	self deny: dataStream dataPoints isEmpty;
		assert: dataStream dataPoints size equals: 1
