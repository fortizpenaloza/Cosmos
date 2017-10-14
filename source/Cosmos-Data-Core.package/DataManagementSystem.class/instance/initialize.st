initialize-release
initialize

	super initialize.

	timeSystem := self unresolvedSystemDependencyTo: #TimeSystemInterface.
	eventNotificationSystem := self unresolvedSystemDependencyTo: #ConditionalTriggersSystemInterface.

	dataStreams := OrderedCollection new