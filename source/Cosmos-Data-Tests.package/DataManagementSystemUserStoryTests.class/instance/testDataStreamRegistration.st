tests
testDataStreamRegistration

	| dataStream |

	dataStream := self dataManagementSystem
		registerStreamNamed: 'Temperature'.

	self
		assert: dataStream name equals: 'Temperature';
		assert: dataStream creationDateTime
			equals: self timeSystem dateTime