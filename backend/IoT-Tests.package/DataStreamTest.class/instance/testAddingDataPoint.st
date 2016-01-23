tests
testAddingDataPoint

	| dataStream |

	dataStream := DataStream 
		named: 'Temperature' 
		createdOn: self septemberSixthOf2015AtNoon 
		belongingTo: self dataChannel.
				
	self assert: dataStream dataPoints isEmpty.
	
	dataStream add: (DataPoint on: self octoberFirstOf2015AtMidnight holding: 10).
	self deny: dataStream dataPoints isEmpty;
		assert: dataStream dataPoints size equals: 1
