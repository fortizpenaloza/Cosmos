Class {
	#name : #ActionEvaluatorTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'evaluator',
		'wasNotified'
	],
	#category : #'Cosmos-ActionEvaluator-Tests'
}

{ #category : #accessing }
ActionEvaluatorTest >> currentDateTime [

	^ (rootSystem >> #TimeSystemInterface) dateTime
]

{ #category : #'private - mocking' }
ActionEvaluatorTest >> eventNotificationSystem [

	^ rootSystem >> #EventNotificationSystemInterface
]

{ #category : #'tests support' }
ActionEvaluatorTest >> handleActionEvaluatedOn: anEvent [

	wasNotified := true
]

{ #category : #'private - mocking' }
ActionEvaluatorTest >> httpClient [ 
	
	^ ZnClient new
]

{ #category : #tests }
ActionEvaluatorTest >> setUp [

	super setUp.

	evaluator := ActionEvaluator configuredBy: self.
	wasNotified := false.

	self eventNotificationSystem
		subscribe: self
		to: ActionEvaluatedEvent
		toBeNotifiedSending: #handleActionEvaluatedOn:
]

{ #category : #'private - running' }
ActionEvaluatorTest >> setUpRequirements [

	self
		registerSubsystem: (TimeSystem using: SystemTimeSource new);
		registerSubsystem: EventNotificationSystem new
]

{ #category : #tests }
ActionEvaluatorTest >> testEvaluateBlock [

	| wasEvaluated |

	wasEvaluated := false.
	self
		deny: wasEvaluated;
		deny: wasNotified.

	evaluator
		evaluate: (Action named: 'Send YO to Fran' evaluating: [ wasEvaluated := true ]).

	self
		assert: wasEvaluated;
		assert: wasNotified
]

{ #category : #tests }
ActionEvaluatorTest >> testEventHandling [

	| action wasEvaluated |

	wasEvaluated := false.
	action := Action
		named: 'Send YO to Fran'
		evaluating: [ wasEvaluated := true ].

	self
		deny: wasEvaluated;
		deny: wasNotified.

	evaluator handleEvaluateActionOn: (EvaluateActionEvent of: action).

	self
		assert: wasEvaluated;
		assert: wasNotified
]

{ #category : #tests }
ActionEvaluatorTest >> testSendHttpRequest [

	self
		withServerDo: [ :server | 
			| wasEvaluated |

			wasEvaluated := false.

			server
				onRequestRespond: [ :request | 
					wasEvaluated := true.
					ZnResponse noContent ].
			self
				deny: wasEvaluated;
				deny: wasNotified.

			evaluator
				evaluate:
					(Action
						named: 'Send YO to Fran'
						sending: (ZnRequest get: server localUrl)).

			self
				assert: wasEvaluated;
				assert: wasNotified ]
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
