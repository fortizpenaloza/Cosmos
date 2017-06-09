initialize-release
initializeUsing: anIdentifierProvider

	self initialize.

	timeSystem := self
		unresolvedSystemDependencyTo: TimeSystemInterface.
	eventNotificationSystem := self
		unresolvedSystemDependencyTo: ConditionalTriggersSystemInterface.

	identifierProvider := anIdentifierProvider.
	dataChannels := Set new.
	dataStreams := OrderedCollection new