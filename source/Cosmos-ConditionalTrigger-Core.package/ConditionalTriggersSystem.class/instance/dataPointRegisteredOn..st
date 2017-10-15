events handling
dataPointRegisteredOn: anEvent

	triggersToFireOnDataPointRegistration
		select: [ :trigger | trigger key = anEvent dataStream ]
		thenDo: [ :trigger | 
			trigger value
				ifSatisfiedDo: [ :action | 
					eventNotificationSystem
						notifySubscribersTo: (EvaluateActionEvent of: action) ] ]