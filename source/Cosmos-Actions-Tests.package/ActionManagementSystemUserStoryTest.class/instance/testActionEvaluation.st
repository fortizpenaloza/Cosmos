tests
testActionEvaluation

	| actionEvaluator action |

	actionEvaluator := ActionEvaluator new.

	self eventNotificationSystem
		subscribe: actionEvaluator
		to: EvaluateActionEvent
		toBeNotifiedSending: #evaluateOn:.

	action := self actionManagementSystem
		registerNamed: 'Send YO to Fran'
		toEvaluate: (BlockEvaluationPolicy for: [ evaluateAction := true ]).

	self deny: evaluateAction.
	
	self eventNotificationSystem
				notifySubscribersTo: (EvaluateActionEvent of: action).

	self assert: evaluateAction