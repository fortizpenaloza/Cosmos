dependency resolution
resolveDependecies

	eventNotificationSystem := self
		resolveSystemDependencyTo: Interfaces >> #EventNotificationSystemInterface.

	eventNotificationSystem
		subscribe: self
		to: DataPointRegistrationEvent
		toBeNotifiedSending: #dataPointRegisteredOn: