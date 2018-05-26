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
				createdOn: (October first , 2014) atNoon
				toEvaluate: (BlockEvaluationPolicy for: [ evaluated := true ])).
	
	self assert: evaluated
]

{ #category : #tests }
ActionEvaluatorTest >> testActionHTTPRequestEvaluation [

	| evaluated actionEvaluationConfiguration evaluator request |

	evaluated := false.
	self deny: evaluated.

	actionEvaluationConfiguration := PluggableMockObject new
		respondTo: #httpClient
		with: [ 
			PluggableMockObject new
				respondTo: #request: with: [  ];
				respondTo: #get with: [ evaluated := true ] 
		].

	evaluator := ActionEvaluator configuredBy: actionEvaluationConfiguration.
	request := ZnRequest get: 'http://zn.stfx.eu/zn/small.html'.

	self deny: evaluated.

	evaluator
		evaluate:
			(Action
				named: 'Send YO to Fran'
				createdOn: (October first , 2014) atNoon
				toEvaluate: (HTTPRequestEvaluationPolicy for: request)).
	self assert: evaluated
]
