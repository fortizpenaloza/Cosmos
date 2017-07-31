initialize-release
initialize

	super initialize.
	timeSystem := self unresolvedSystemDependencyTo: #TimeSystemInterface.

	prioritizedCommands := OrderedCollection new.
	priorityQueue := PriorityQueue empty