tests
testAccessingLastUpdate

	| dataStream dataPoint |

	dataStream := DataStream named: 'Temperature' createdOn: (October first , 2015) atMidnight belongingTo: self dataChannel.
	
	self
		should: [dataStream lastUpdate]
		raise: ObjectIsUnbound
		withDescription: 'Last update date and time has not been initialized.'.
	
	dataPoint := DataPoint on: (October second, 2015) atMidnight holding: 10.
	dataStream add: dataPoint.
	self assert: dataStream lastUpdate equals: dataPoint timestamp