dependency resolution
resolveDependecies

	timeSystem := self resolveSystemDependencyTo: 'Time System Interface'.
	eventNotificationSystem := self
		resolveSystemDependencyTo: 'Event Notification System Interface'