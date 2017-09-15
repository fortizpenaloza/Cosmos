initialize-release
initialize

	super initialize.
	eventNotificationSystem := self
		unresolvedSystemDependencyTo: Interfaces >> #EventNotificationSystemInterface.

	triggersToFireOnDataPointRegistration := OrderedCollection new.
	triggersToFirePeriodically := OrderedCollection new