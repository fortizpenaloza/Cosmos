test
testCurrentValueUnsetUntilDatapointIsAdded

	| dataPoint dataStream |

	dataPoint := DataPoint on: self septemberTenthOf2014AtNoon holding: 10.
	dataStream := DataStream identifiedBy: 'temp'.
	
	self
		should: [dataStream currentValue]
		raise: ObjectIsUnbound
		description: 'Current value hasn''t been set'.
	
	dataStream add: dataPoint.
	self assert: dataStream currentValue equals: dataPoint value