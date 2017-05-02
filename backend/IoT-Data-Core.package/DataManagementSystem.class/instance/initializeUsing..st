initialize-release
initializeUsing: anIdentifierProvider

	super initialize.

	timeSystem := self unresolvedSystemDependencyTo: 'Time System Interface'.
	eventNotificationSystem := self
		unresolvedSystemDependencyTo: 'Conditional Trigger Management System Interface'.

	identifierProvider := anIdentifierProvider.
	dataChannels := Set new.
	dataStreams := OrderedCollection new