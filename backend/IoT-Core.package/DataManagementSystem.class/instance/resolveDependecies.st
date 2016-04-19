dependency resolution
resolveDependecies

	timeSystem := self resolveSystemDependencyTo: 'Time System Interface'.
	conditionalTriggerManagementSystem := self
		resolveSystemDependencyTo: 'Conditional Triggers System Interface'