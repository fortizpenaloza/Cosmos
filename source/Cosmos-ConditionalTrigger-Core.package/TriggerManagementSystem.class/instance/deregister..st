private-managing
deregister: aRegisteredTrigger 
	
	triggers remove: aRegisteredTrigger .
	aRegisteredTrigger deregisterFrom: self