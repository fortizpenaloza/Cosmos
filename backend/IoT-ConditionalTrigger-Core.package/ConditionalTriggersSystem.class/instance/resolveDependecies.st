dependency resolution
resolveDependecies

	eventNotificationSystem := self
		resolveSystemDependencyTo: EventNotificationSystem implementedInterface.

	eventNotificationSystem
		subscribe: self
		to: DataPointRegistrationEvent
		toBeNotifiedSending: #evaluateDataPointRegistrationTriggersAccordingTo: