tests
testInstanceCreationAndAccessing

	| dataStream |

	dataStream := DataStream 
		named: 'Temperature' 
		createdOn: self octoberFirstOf2015AtMidnight 
		belongingTo: self dataChannel.

	self
		assert: dataStream name equals: 'Temperature';
		assert: dataStream dataChannel equals: self dataChannel;
		assert: dataStream creationDateTime equals: self octoberFirstOf2015AtMidnight;
		assert: dataStream dataPoints isEmpty