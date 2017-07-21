tests
testQueryingDataStreamByName

	self dataManagementSystem registerStreamNamed: 'Temperature'.

	self dataManagementSystem
		streamNamed: 'Temperature'
		ifFound: [ :dataStream | 
			self
				assert: dataStream name equals: 'Temperature';
				assert: dataStream creationDateTime equals: self timeSystem dateTime;
				assert: dataStream dataPoints isEmpty ]
		ifNone: [ self fail ]