test
testDataChannelRegistration

	| dataChannel |

	dataChannel := self dataManagementSystem registerChannelNamed: 'Channel #1'.

	self
		assert: dataChannel identifier equals: 1;
		assert: dataChannel name equals: 'Channel #1';
		assert: dataChannel creationDateTime equals: self septemberSixth2015AtNoon 