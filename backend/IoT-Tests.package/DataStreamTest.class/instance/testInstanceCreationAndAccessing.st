tests
testInstanceCreationAndAccessing

	| dataStream |

	dataStream := DataStream named: 'Temperature' createdOn: (October first , 2015) atMidnight belongingTo: self dataChannel.

	self
		assert: dataStream name equals: 'Temperature';
		assert: dataStream dataChannel equals: self dataChannel;
		assert: dataStream creationDateTime equals: (October first , 2015) atMidnight;
		assert: dataStream dataPoints isEmpty