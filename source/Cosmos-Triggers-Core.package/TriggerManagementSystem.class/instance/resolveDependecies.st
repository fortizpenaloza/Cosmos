dependency resolution
resolveDependecies

	timeSystem := self resolveSystemDependencyTo: #TimeSystemInterface.
	eventNotificationSystem := self
		resolveSystemDependencyTo: #EventNotificationSystemInterface.

	eventNotificationSystem
		subscribe: self
		to: DataPointRegistrationEvent
		toBeNotifiedSending: #dataPointRegisteredOn:.
	
	eventNotificationSystem subscribe: self to: TickEvent toBeNotifiedSending: #havePassed: