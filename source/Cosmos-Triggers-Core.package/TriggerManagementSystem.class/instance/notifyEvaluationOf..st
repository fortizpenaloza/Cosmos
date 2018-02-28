events handling
notifyEvaluationOf: action

	^ eventNotificationSystem notifySubscribersTo: (EvaluateActionEvent of: action)