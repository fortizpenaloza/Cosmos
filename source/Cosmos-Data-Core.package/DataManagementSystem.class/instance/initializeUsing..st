initialize-release
initializeUsing: anIdentifierProvider

	self initialize.

	timeSystem := self
		unresolvedSystemDependencyTo: Interfaces >> #TimeSystemInterface.
	eventNotificationSystem := self
		unresolvedSystemDependencyTo: Interfaces >> #ConditionalTriggersSystemInterface.

	dataStreams := OrderedCollection new