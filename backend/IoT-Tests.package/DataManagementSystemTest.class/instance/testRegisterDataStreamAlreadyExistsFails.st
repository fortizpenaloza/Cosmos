test
testRegisterDataStreamAlreadyExistsFails
	| feed dataStream |
	feed := DataChannel
		identifiedBy: 1
		named: #DataChannel
		createdOn: self timeSystem dateTime.
	dataStream := DataStream identifiedBy: 'x'.
	self assert: self dataManagementSystem feeds isEmpty.
	self dataManagementSystem register: feed.
	self dataManagementSystem register: dataStream to: feed.
	self deny: self dataManagementSystem feeds isEmpty.
	self assert: self dataManagementSystem feeds size equals: 1.
	self
		should: [ self dataManagementSystem register: dataStream to: feed ]
		raise: ObjectAlreadyInSystem
		withDescription: 'Data stream already exists in system'