dependency resolution
resolveDependecies

	timeSystem := self resolveSystemDependencyTo: #TimeSystemInterface.

	eventNotificationSystem := self resolveSystemDependencyTo: #EventNotificationSystemInterface