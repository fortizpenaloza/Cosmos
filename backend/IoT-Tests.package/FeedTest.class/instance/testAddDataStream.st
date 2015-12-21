test
testAddDataStream

	| feed |

	feed := Feed
		identifiedBy: 1
		named: 'Feed'
		describedAs: 'Feed description'
		createdOn: (September eleventh , 2014) atNoon.
		
	self assert: feed dataStreams isEmpty.
	
	feed add: (DataStream identifiedBy: 'test').
	
	self deny: feed dataStreams isEmpty.
	self assert: feed dataStreams size equals: 1