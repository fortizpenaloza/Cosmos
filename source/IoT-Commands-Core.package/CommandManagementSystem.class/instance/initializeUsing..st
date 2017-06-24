initialize-release
initializeUsing: anIdentifierProvider  

	self initialize.
	timeSystem := self unresolvedSystemDependencyTo: TimeSystemInterface.

	identifierProvider := anIdentifierProvider.
	commandPriorityQueues := Dictionary new.

	