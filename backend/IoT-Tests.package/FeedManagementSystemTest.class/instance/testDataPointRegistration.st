test
testDataPointRegistration

	| feed dataStream |

	feed := Feed
		identifiedBy: 1
		named: 'Feed'
		describedAs: 'Test feed'
		createdOn: self timeSystem dateTime.
	dataStream := DataStream identifiedBy: 'test'.

	self feedManagementSystem register: feed.
	self feedManagementSystem register: dataStream to: feed.

	self feedManagementSystem register: 10 to: dataStream of: feed.
	self assert: dataStream currentValue equals: 10;
		assert: dataStream lastUpdate equals: self timeSystem dateTime;
		withTheOnlyOneIn: dataStream dataPoints do: [ :dataPoint | 
				self assert: dataPoint value equals: 10;
				assert: dataPoint timestamp equals: self timeSystem dateTime ]