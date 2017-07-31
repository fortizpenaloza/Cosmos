initialize-release
initializeUsing: anIdentifierProvider

	self initialize.

	timeSystem := self unresolvedSystemDependencyTo: #TimeSystemInterface.
	eventNotificationSystem := self unresolvedSystemDependencyTo: #ConditionalTriggersSystemInterface.

	dataStreams := OrderedCollection new