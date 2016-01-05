test
testIsSafistied

	| condition |

	condition := DataStreamHasNotBeenUpdatedTriggerCondition 
		querying: self
		toCheckIf: self
		hasNotBeenUpdatedForMoreThan: (TimeUnits minute with: 10).
		
	dateTime := (September tenth , 2014) atTimeOfDay: (TimeOfDay hours:19). 
	lastUpdate := (September tenth , 2014) atTimeOfDay: (TimeOfDay hours:19). 
	self deny: condition isSatisfied.
	
	dateTime := (September tenth , 2014) atTimeOfDay: (TimeOfDay hours:19 minutes: 20). 
	lastUpdate := (September tenth , 2014) atTimeOfDay: (TimeOfDay hours:19). 
	self assert: condition isSatisfied.
	
	dateTime := (September tenth , 2014) atTimeOfDay: (TimeOfDay hours:19 minutes: 9). 
	lastUpdate := (September tenth , 2014) atTimeOfDay: (TimeOfDay hours:19). 
	self deny: condition isSatisfied.
