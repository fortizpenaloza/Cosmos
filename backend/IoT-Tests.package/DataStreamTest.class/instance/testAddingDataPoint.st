test
testAddingDataPoint

	| datastream datapoint |

	datapoint := DataPoint on: self septemberTenthOf2014AtNoon holding: 10.
	datastream := DataStream identifiedBy: 'temp'.

	self assert: datastream dataPoints isEmpty.
	datastream add: datapoint.
	self deny: datastream dataPoints isEmpty.
	self assert: datastream dataPoints size equals: 1