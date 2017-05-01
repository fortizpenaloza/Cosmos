initialize-release
initialize

	super initialize.
	eventNotificationSystem := self
		unresolvedSystemDependencyTo: 'Event Notification System Interface'.

	triggersToFireOnDataPointRegistration := OrderedCollection new.
	triggersToFirePeriodically := OrderedCollection new