initialize-release
initialize

	super initialize.
	eventNotificationSystem := self unresolvedSystemDependencyTo: #EventNotificationSystemInterface.

	triggersToFireOnDataPointRegistration := OrderedCollection new.
	triggersToFirePeriodically := OrderedCollection new