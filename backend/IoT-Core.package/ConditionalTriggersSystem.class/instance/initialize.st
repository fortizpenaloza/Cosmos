initialize-release
initialize
 
	super initialize.
	
	triggersToFireOnDataPointRegistration := OrderedCollection new.
	triggersToFirePeriodically := OrderedCollection new.
	