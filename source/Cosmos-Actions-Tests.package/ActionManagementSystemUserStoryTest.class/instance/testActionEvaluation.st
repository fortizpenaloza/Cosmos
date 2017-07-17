tests
testActionEvaluation

	| action |
	
	self eventNotificationSystem subscribe: self to: EvaluateActionEvent toBeNotifiedSending: #setEvaluateActionToTrue.
	
	action := self actionManagementSystem
		registerNamed: 'Send YO to Fran'
		toEvaluate: [ "empty" ].

	self deny: evaluateAction.
	self actionManagementSystem evaluateNamed: 'Send YO to Fran'.
	self assert: evaluateAction