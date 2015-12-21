test
testAddingDataPointSetsLastUpdateToDataPointsTimestamp

	| dataStream dataPoint |

	dataPoint := DataPoint on: self septemberTenthOf2014AtNoon holding: 10.
	dataStream := DataStream identifiedBy: 'temp'.

	dataStream add: dataPoint.
	self assert: dataStream lastUpdate equals: dataPoint timestamp