initialize-release
initialize

	super initialize.

	timeSystem := self unresolvedSystemDependencyTo: #TimeSystemInterface.
	actions := OrderedCollection new