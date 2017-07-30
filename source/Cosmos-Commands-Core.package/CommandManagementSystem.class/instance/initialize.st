initialize-release
initialize

	super initialize.
	timeSystem := self
		unresolvedSystemDependencyTo: Interfaces >> #TimeSystemInterface.

	prioritizedCommands := OrderedCollection new.
	priorityQueue := PriorityQueue empty