tests
testDataStreamRegistration

	| interface |

	self dataManagementSystem
		streamNamed: 'pH'
		ifFound: [ :dataStream | self fail ]
		ifNone: [ "do nothing" ].

	interface := DataAPI workingWith: rootSystem.
	interface registerStreamFrom: '{"name": "pH"}'.

	self dataManagementSystem
		streamNamed: 'pH'
		ifFound: [ :dataStream | 
			self
				assert: dataStream name equals: 'pH';
				assert: dataStream creationDateTime
					equals: self timeSystem dateTime;
				assert: dataStream dataPoints isEmpty ]
		ifNone: [ self fail ]