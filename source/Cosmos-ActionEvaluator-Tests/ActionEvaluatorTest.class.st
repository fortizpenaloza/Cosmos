Class {
	#name : #ActionEvaluatorTest,
	#superclass : #TestCase,
	#category : 'Cosmos-ActionEvaluator-Tests'
}

{ #category : #tests }
ActionEvaluatorTest >> testEvaluateBlock [

	| evaluated |

	evaluated := false.
	self deny: evaluated.

	ActionEvaluator new
		evaluate:
			(Action named: 'Send YO to Fran' evaluating: [ evaluated := true ]).

	self assert: evaluated
]

{ #category : #tests }
ActionEvaluatorTest >> testEventHandling [

	| actionEvaluator action actionWasEvaluated |

	actionWasEvaluated := false.
	action := Action
		named: 'Send YO to Fran'
		evaluating: [ actionWasEvaluated := true ].
	actionEvaluator := ActionEvaluator new.

	self deny: actionWasEvaluated.

	actionEvaluator handleEvaluateActionOn: (EvaluateActionEvent of: action).

	self assert: actionWasEvaluated
]

{ #category : #tests }
ActionEvaluatorTest >> testSendHttpRequest [

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
				sending: request).
	self assert: evaluated
]
