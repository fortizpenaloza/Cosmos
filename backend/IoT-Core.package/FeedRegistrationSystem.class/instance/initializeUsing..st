initialize-release
initializeUsing: anIdentifierProvider

	super initialize.

	timeSystem := self unresolvedSystemDependencyTo: TimeSystemInterface.
	conditionalTriggerManagementSystem := self unresolvedSystemDependencyTo: ConditionalTriggerManagementSystemInterface.
	
	identifierProvider := SequentialNumberProvider new.
	feeds := Dictionary new.