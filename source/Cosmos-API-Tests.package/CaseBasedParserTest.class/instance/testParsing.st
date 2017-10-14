tests
testParsing

	| parser |
	
	parser := CaseBasedParser new
		parsing: 'high' to: QueuePriority high;
		parsing: 'medium' to: QueuePriority medium;
		parsing: 'low' to: QueuePriority low;
		yourself.

	self
		assert: (parser parse: 'high') equals: QueuePriority high;
		assert: (parser parse: 'medium') equals: QueuePriority medium;
		assert: (parser parse: 'low') equals: QueuePriority low