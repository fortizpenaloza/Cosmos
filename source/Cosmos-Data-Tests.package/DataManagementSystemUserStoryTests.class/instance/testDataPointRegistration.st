tests
testDataPointRegistration

	| dataStream |
	
	dataStream := self dataManagementSystem
		registerStreamNamed: 'Temperature'.

	self dataManagementSystem register: 10 toStreamNamed: dataStream name.

	self
		withTheOnlyOneIn: dataStream dataPoints
		do: [ :dataPoint | 
			self
				assert: dataPoint value equals: 10;
				assert: dataPoint timestamp equals: self septemberSixth2015AtNoon ]