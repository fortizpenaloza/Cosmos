initialize-release
initializeUsing: anIdentifierProvider  

	super initialize.
	timeSystem := self unresolvedSystemDependencyTo: 'Time System Interface'.

	identifierProvider := anIdentifierProvider.
	commandPriorityQueues := Dictionary new.

	