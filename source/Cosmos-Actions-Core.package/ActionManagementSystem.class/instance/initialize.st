initialize-release
initialize

	super initialize.

	timeSystem := self
		unresolvedSystemDependencyTo: Interfaces >> #TimeSystemInterface.
	eventNotificationSystem := self
		unresolvedSystemDependencyTo: Interfaces >> #EventNotificationSystemInterface.

	actions := OrderedCollection new