tests
testPoppingElementRespectsItsPriority

	| priorityQueue |
	
	priorityQueue := PriorityCommandQueue empty.
	priorityQueue push: (PriorityCommand holding: 2 with: CommandPriority low).
	priorityQueue push: (PriorityCommand holding: 3 with: CommandPriority medium).
	priorityQueue push: (PriorityCommand holding: 4 with: CommandPriority high).
	
	self assert: priorityQueue pop command equals: 4.
	self assert: priorityQueue pop command equals: 3.
	self assert: priorityQueue pop command equals: 2.