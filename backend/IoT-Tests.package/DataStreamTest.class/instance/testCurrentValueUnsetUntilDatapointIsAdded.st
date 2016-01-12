test
testCurrentValueUnsetUntilDatapointIsAdded

	| dataPoint dataStream |

	dataPoint := DataPoint on: self septemberTenthOf2014AtNoon holding: 10.
	dataStream := DataStream identifiedBy: 'temp'.
	
	self
		should: [dataStream currentValue]
		raise: ObjectIsUnbound
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'Current value has not been initialized.' ].
	
	dataStream add: dataPoint.
	self assert: dataStream currentValue equals: dataPoint value