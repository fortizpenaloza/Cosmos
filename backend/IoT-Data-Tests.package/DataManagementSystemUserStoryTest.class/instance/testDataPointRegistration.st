tests
testDataPointRegistration

	| dataChannel dataStream |
	
	dataChannel := self dataManagementSystem registerChannelNamed: 'Channel #1'.
	dataStream := self dataManagementSystem
		registerStreamNamed: 'Temperature'
		toChannelIdentifiedBy: dataChannel identifier.
		
	self dataManagementSystem
		register: 10
		toStreamNamed: dataStream name
		ofChannelIdentifiedBy: dataChannel identifier.
	
	self
		withTheOnlyOneIn: dataStream dataPoints
		do: [ :dataPoint | 
			self assert: dataPoint value equals: 10;
				assert: dataPoint timestamp equals: self septemberSixth2015AtNoon ]