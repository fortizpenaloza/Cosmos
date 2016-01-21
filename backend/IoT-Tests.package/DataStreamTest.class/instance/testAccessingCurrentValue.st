tests
testAccessingCurrentValue

	| dataStream dataPoint |

	dataStream := DataStream named: 'Temperature' createdOn: (October first , 2015) atMidnight belongingTo: self dataChannel.
	
	self
		should: [dataStream currentValue]
		raise: ObjectIsUnbound
		withDescription: 'Current value has not been initialized.'.
	
	dataPoint := DataPoint on: (October second, 2015) atMidnight holding: 10.
	dataStream add: dataPoint.
	self assert: dataStream currentValue equals: 10
