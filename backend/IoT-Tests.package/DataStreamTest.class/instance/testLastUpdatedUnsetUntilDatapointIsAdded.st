test
testLastUpdatedUnsetUntilDatapointIsAdded

	| dataStream dataPoint |

	dataPoint := DataPoint on: self septemberTenthOf2014AtNoon holding: 10.
	dataStream := DataStream identifiedBy: 'temp'.
	
	self
		should: [dataStream lastUpdate]
		raise: ObjectIsUnbound
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'Last update date and time has not been initialized.' ].
			
	dataStream add: dataPoint.
	self assert: dataStream lastUpdate equals: dataPoint timestamp