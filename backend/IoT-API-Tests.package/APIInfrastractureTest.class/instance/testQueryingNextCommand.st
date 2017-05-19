tests
testQueryingNextCommand

	| response |

	response := ZnEasy
		get: 'http://localhost:8010/priority-queue/' , '1' , '/next/'.
		
	self
		assert: response code equals: 200;
		assert: response contents equals: self queryingNextCommandFromPriorityQueueAnswer