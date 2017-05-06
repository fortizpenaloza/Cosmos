dependency resolution
resolveDependecies

	eventNotificationSystem := self
		resolveSystemDependencyTo: 'Event Notification System Interface'.

	eventNotificationSystem
		subscribe: self
		to: DataPointRegistrationEvent
		toBeNotifiedSending: #evaluateDataPointRegistrationTriggersAccordingTo: