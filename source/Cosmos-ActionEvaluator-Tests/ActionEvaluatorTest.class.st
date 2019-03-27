Class {
	#name : #ActionEvaluatorTest,
	#superclass : #TestCase,
	#instVars : [
		'evaluator',
		'wasEvaluated',
		'timeSource',
		'pendingActions',
		'evaluatedActions'
	],
	#category : #'Cosmos-ActionEvaluator-Tests'
}

{ #category : #running }
ActionEvaluatorTest >> setUp [

	super setUp.

	wasEvaluated := false.
	pendingActions := WaitfreeQueue new.
	evaluatedActions := WaitfreeQueue new.

	timeSource := SystemTimeSource new.

	evaluator := ActionEvaluator
		evaluatingAll: pendingActions
		using: (ActionEvaluatorConfiguration workingWith: timeSource)
		registeringEvaluationsOn: evaluatedActions
]

{ #category : #running }
ActionEvaluatorTest >> tearDown [ 

	evaluator stop
]

{ #category : #tests }
ActionEvaluatorTest >> testEvaluateBlock [

	self
		deny: wasEvaluated;
		assert: pendingActions isEmpty;
		assert: evaluatedActions isEmpty.

	pendingActions
		enqueue: (Action named: 'Send YO to Fran' evaluating: [ wasEvaluated := true ]).

	self
		assert: pendingActions size equals: 1;
		assert: evaluatedActions isEmpty.

	evaluator start.

	self
		wait: 10 milliSeconds
		andDo: [ self
				assert: wasEvaluated;
				assert: pendingActions isEmpty;
				assert: evaluatedActions size equals: 1 ]
]

{ #category : #tests }
ActionEvaluatorTest >> testSendHttpRequest [

	self
		withServerDo: [ :server | 
			server
				onRequestRespond: [ :request | 
					wasEvaluated := true.
					ZnResponse noContent ].

			self
				deny: wasEvaluated;
				assert: pendingActions isEmpty;
				assert: evaluatedActions isEmpty.

			pendingActions
				enqueue:
					(Action
						named: 'Send YO to Fran'
						sending: (ZnRequest get: server localUrl)).

			self
				assert: pendingActions size equals: 1;
				assert: evaluatedActions isEmpty.

			evaluator start.

			self
				wait: 100 milliSeconds
				andDo: [ self
						assert: wasEvaluated;
						assert: pendingActions isEmpty;
						assert: evaluatedActions size equals: 1 ] ]
]

{ #category : #'tests support' }
ActionEvaluatorTest >> wait: aDuration andDo: aBlock [

	(Delay forDuration: aDuration) wait.
	aBlock value
]

{ #category : #'tests support' }
ActionEvaluatorTest >> withServerDo: aBlock [

	| server |

	server := ZnServer on: 1700 + 32 atRandom.
	[ server start.

	self
		assert: server isRunning & server isListening
		description:
			('Failed to start server on port {1}. Is there one already?'
				format: {server port}).
				
	aBlock cull: server ]
		ensure: [ server stop ]
]
