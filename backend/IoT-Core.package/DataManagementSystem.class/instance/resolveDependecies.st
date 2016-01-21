dependency resolution
resolveDependecies

	timeSystem := self resolveSystemDependencyTo: 'Time System Interface'.
	conditionalTriggerManagementSystem := self
		resolveSystemDependencyTo: 'Conditional Trigger Management System Interface'