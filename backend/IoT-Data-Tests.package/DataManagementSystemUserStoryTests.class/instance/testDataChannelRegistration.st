tests
testDataChannelRegistration

	| dataChannel |

	dataChannel := self dataManagementSystem
		registerChannelNamed: 'Channel #1'.

	self
		assert: dataChannel identifier equals: self startingIdentifier;
		assert: dataChannel name equals: 'Channel #1';
		assert: dataChannel creationDateTime
			equals: self septemberSixth2015AtNoon.

	identifierProvider setNextTo: 2.
	timeSource setTimeTo: self septemberSixth2015AtTwelveOFivePM.

	dataChannel := self dataManagementSystem
		registerChannelNamed: 'Channel #2'.

	self
		assert: dataChannel identifier equals: 2;
		assert: dataChannel name equals: 'Channel #2';
		assert: dataChannel creationDateTime
			equals: self septemberSixth2015AtTwelveOFivePM