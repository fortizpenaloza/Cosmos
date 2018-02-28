private-managing
deregister: aTrigger toStopTriggeringAfterDataPointRegistrationOn: aDataStream 
	
	(self triggersToTriggerAfterDataPointRegistrationOn: aDataStream) remove: aTrigger 	