tests
testActionHTTPRequestEvaluation

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