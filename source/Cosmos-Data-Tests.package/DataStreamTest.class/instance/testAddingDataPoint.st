tests
testAddingDataPoint

	| dataStream |

	dataStream := DataStream
		named: 'Temperature'
		createdOn: self septemberSixthOf2014AtNoon.

	self assert: dataStream dataPoints isEmpty.

	dataStream
		add: (DataPoint on: self octoberFirstOf2014AtMidnight holding: 10).
	self
		deny: dataStream dataPoints isEmpty;
		assert: dataStream dataPoints size equals: 1