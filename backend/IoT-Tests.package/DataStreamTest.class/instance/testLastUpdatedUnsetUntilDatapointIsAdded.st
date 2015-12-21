test
testLastUpdatedUnsetUntilDatapointIsAdded

	| dataStream dataPoint |

	dataPoint := DataPoint on: self septemberTenthOf2014AtNoon holding: 10.
	dataStream := DataStream identifiedBy: 'temp'.
	
	self
		should: [dataStream lastUpdate]
		raise: ObjectIsUnbound
		description: 'Last update date and time is not yet defined.'.
	
	dataStream add: dataPoint.
	self assert: dataStream lastUpdate equals: dataPoint timestamp