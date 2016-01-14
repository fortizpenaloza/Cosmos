tests
testInstanceCreation

	| commandQueue |

	commandQueue := CommandQueue identifiedBy: 1 named: 'CommandQueue for test' createdOn: (July twentyfourth , 2015) atMidnight.

	self
		assert: commandQueue identifier equals: 1;
		assert: commandQueue name equals: 'CommandQueue for test';
		assert: commandQueue dateTime equals: (July twentyfourth , 2015) atMidnight