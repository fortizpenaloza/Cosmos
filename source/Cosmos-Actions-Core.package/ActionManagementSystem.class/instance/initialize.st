initialize-release
initialize

	super initialize.

	timeSystem := self unresolvedSystemDependencyTo: #TimeSystemInterface.
	eventNotificationSystem := self unresolvedSystemDependencyTo: #EventNotificationSystemInterface.

	actions := OrderedCollection new