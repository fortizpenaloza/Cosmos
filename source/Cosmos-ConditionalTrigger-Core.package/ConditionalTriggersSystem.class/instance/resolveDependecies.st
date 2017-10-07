dependency resolution
resolveDependecies

	eventNotificationSystem := self resolveSystemDependencyTo: #EventNotificationSystemInterface.

	eventNotificationSystem subscribe: self to: DataPointRegistrationEvent toBeNotifiedSending: #dataPointRegisteredOn: