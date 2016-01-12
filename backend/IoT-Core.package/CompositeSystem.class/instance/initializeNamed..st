initialize-release
initializeNamed: aName
	
	super initialize.
	
	name := aName.
	subsystems := OrderedCollection new