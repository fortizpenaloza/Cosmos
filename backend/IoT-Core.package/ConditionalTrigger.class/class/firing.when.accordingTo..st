instance creation
firing: anAction when: aCondition accordingTo: aTriggeringPolicy 

	self flag: 'accordingTo: es más el when firing: anAction when: aTriggeringPolicy ifSafisfies: aCondition'.

	^ self new initializeFiring: anAction when: aCondition accordingTo: aTriggeringPolicy 