tests
testAccessingLastUpdate

	| dataStream dataPoint |

	dataStream := DataStream named: 'Temperature' createdOn: self septemberSixthOf2015AtNoon belongingTo: self dataChannel.
	
	self
		should: [dataStream lastUpdate]
		raise: ObjectIsUnbound
		withDescription: 'Last update date and time has not been initialized.'.
	
	dataPoint := DataPoint on: self octoberFirstOf2015AtMidnight holding: 10.
	dataStream add: dataPoint.
	self assert: dataStream lastUpdate equals: dataPoint timestamp