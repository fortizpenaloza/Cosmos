tests
testDataChannelRegistration

	| dataChannel |
	
	identifierProvider setNextTo: self identifier.
	dataChannel := self dataManagementSystem registerChannelNamed: 'Channel #1'.

	self
		assert: dataChannel identifier equals: self identifier;
		assert: dataChannel name equals: 'Channel #1';
		assert: dataChannel creationDateTime equals: self septemberSixth2015AtNoon 