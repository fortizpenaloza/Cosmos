initialize-release
initialize

	super initialize.
	eventNotificationSystem := self unresolvedSystemDependencyTo: #EventNotificationSystemInterface.
	timeSystem := self unresolvedSystemDependencyTo: #TimeSystemInterface.

	triggers := OrderedCollection new.
	triggersToTriggerAfterDataPointRegistration := Dictionary new.
	triggersToTriggerPeriodically := Dictionary new