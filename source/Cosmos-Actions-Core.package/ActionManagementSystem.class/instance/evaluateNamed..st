evaluating
evaluateNamed: aName

	actions
		detect: [ :action | action name = aName ]
		ifFound: [ :action | eventNotificationSystem notifySubscribersTo: (EvaluateActionEvent of: action) ]
		ifNone: [ ObjectNotFoundInSystem signal: 'Action does not exists in system' ]