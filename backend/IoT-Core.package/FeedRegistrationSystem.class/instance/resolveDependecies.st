dependency resolution
resolveDependecies

	timeSystem := self resolveSystemDependencyTo: TimeSystemInterface.
	conditionalTriggerManagementSystem := self resolveSystemDependencyTo: ConditionalTriggerManagementSystemInterface 