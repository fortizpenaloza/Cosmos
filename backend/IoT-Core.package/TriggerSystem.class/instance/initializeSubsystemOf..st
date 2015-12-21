initialize-release
initializeSubsystemOf: aParentSystem
 
	aParentSystem register: self as: #triggerSystem.
	parentSystem := aParentSystem.
	
	triggersToFireOnDataPointRegistration := OrderedCollection new.
	triggersToFirePeriodically := OrderedCollection new.
	