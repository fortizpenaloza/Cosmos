Class {
	#name : #ActionEvaluatorTest,
	#superclass : #TestCase,
	#category : 'Cosmos-ActionEvaluator-Tests'
}

{ #category : #tests }
ActionEvaluatorTest >> testActionBlockEvaluation [

	| evaluated |

	evaluated := false.
	self deny: evaluated.

	ActionEvaluator new
		evaluate:
			(Action
				named: 'Send YO to Fran'
				evaluating: (EvaluateBlockPolicy for: [ evaluated := true ])).

	self assert: evaluated
]

{ #category : #tests }
ActionEvaluatorTest >> testActionEvaluationTroughtEventNotification [

	| actionEvaluator action actionWasEvaluated |
	
	actionWasEvaluated := false.
	action := Action
		named: 'Send YO to Fran'
		evaluating: (EvaluateBlockPolicy for: [ actionWasEvaluated := true ]).
	actionEvaluator := ActionEvaluator new.
	
	self deny: actionWasEvaluated.
	
	actionEvaluator evaluateOn: (EvaluateActionEvent of: action).

	self assert: actionWasEvaluated
]

{ #category : #tests }
ActionEvaluatorTest >> testActionHTTPRequestEvaluation [

	| evaluated actionEvaluationConfiguration evaluator request |

	evaluated := false.
	self deny: evaluated.

	actionEvaluationConfiguration := PluggableMockObject new
		respondTo: #httpClient
		with: [ PluggableMockObject new
				respondTo: #request: with: [  ];
				respondTo: #get with: [ evaluated := true ] ].

	evaluator := ActionEvaluator
		configuredBy: actionEvaluationConfiguration.
	request := ZnRequest get: 'http://zn.stfx.eu/zn/small.html'.

	self deny: evaluated.

	evaluator
		evaluate:
			(Action
				named: 'Send YO to Fran'
				evaluating: (SendHttpRequestPolicy sending: request)).
	self assert: evaluated
]
