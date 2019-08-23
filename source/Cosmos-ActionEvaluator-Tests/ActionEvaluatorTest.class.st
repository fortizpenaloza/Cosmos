Class {
	#name : #ActionEvaluatorTest,
	#superclass : #TestCase,
	#instVars : [
		'evaluator',
		'wasEvaluated',
		'timeSource',
		'pendingActionsQueue',
		'actionEvaluationsQueue'
	],
	#category : #'Cosmos-ActionEvaluator-Tests'
}

{ #category : #running }
ActionEvaluatorTest >> setUp [

	super setUp.

	wasEvaluated := false.
	pendingActionsQueue := AtomicSharedQueue new.
	actionEvaluationsQueue := AtomicSharedQueue new.

	timeSource := SystemTimeSource new.

	evaluator := ActionEvaluator
		evaluatingActionsFrom: pendingActionsQueue
		using: (ActionEvaluatorConfiguration workingWith: timeSource)
		registeringEvaluationsInto: actionEvaluationsQueue
]

{ #category : #running }
ActionEvaluatorTest >> tearDown [ 

	evaluator stop
]

{ #category : #tests }
ActionEvaluatorTest >> testEvaluateBlock [

	self
		deny: wasEvaluated;
		assert: pendingActionsQueue isEmpty;
		assert: actionEvaluationsQueue isEmpty.

	pendingActionsQueue
		enqueue: (Action named: 'Send YO to Fran' evaluating: [ wasEvaluated := true ]).

	self
		assert: pendingActionsQueue size equals: 1;
		assert: actionEvaluationsQueue isEmpty.

	evaluator start.

	self
		wait: 10 milliSeconds
		thenDo: [ self
				assert: wasEvaluated;
				assert: pendingActionsQueue isEmpty;
				assert: actionEvaluationsQueue size equals: 1 ]
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
				assert: pendingActionsQueue isEmpty;
				assert: actionEvaluationsQueue isEmpty.

			pendingActionsQueue
				enqueue:
					(Action
						named: 'Send YO to Fran'
						sending: (ZnRequest get: server localUrl)).

			self
				assert: pendingActionsQueue size equals: 1;
				assert: actionEvaluationsQueue isEmpty.

			evaluator start.

			self
				wait: 100 milliSeconds
				thenDo: [ self
						assert: wasEvaluated;
						assert: pendingActionsQueue isEmpty;
						assert: actionEvaluationsQueue size equals: 1 ] ]
]

{ #category : #'tests support' }
ActionEvaluatorTest >> wait: aDuration thenDo: aBlock [

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
