Class {
	#name : #ActionTest,
	#superclass : #TestCase,
	#category : #'Cosmos-Actions-Tests'
}

{ #category : #'tests support' }
ActionTest >> httpClient [
	
	^ ZnClient new
]

{ #category : #tests }
ActionTest >> testEvaluateBlock [

	| action wasEvaluated |
			
	wasEvaluated := false.
	action := Action named: 'Do nothing' evaluating: [ wasEvaluated := true ].

	self deny: wasEvaluated.	
	action evaluateWithin: self.
	self assert: wasEvaluated 
]

{ #category : #tests }
ActionTest >> testHash [

	| action equivalentAction differentAction |

	action := Action named: 'Do nothing' evaluating: [ "do nothing" ].

	equivalentAction := Action
		named: 'Do nothing'
		evaluating: [ "do nothing" ].

	differentAction := Action
		named: 'Do something'
		evaluating: [ "do something" ].

	self
		assert: action hash equals: equivalentAction hash;
		deny: action hash = differentAction hash
]

{ #category : #tests }
ActionTest >> testInstanceCreationAndAccessing [

	| action |

	action := Action named: 'Do nothing' evaluating: [ "do nothing" ].

	self assert: action name equals: 'Do nothing'
]

{ #category : #tests }
ActionTest >> testSendHttpRequest [

	self
		withServerDo: [ :server | 
			| action wasEvaluated |

			wasEvaluated := false.

			server
				onRequestRespond: [ :request | 
					wasEvaluated := true.
					ZnResponse noContent ].
			self deny: wasEvaluated.

			action := Action
				named: 'Do nothing'
				sending: (ZnRequest get: server localUrl).
			self deny: wasEvaluated.

			action evaluateWithin: self.
			self assert: wasEvaluated ]
]

{ #category : #'tests support' }
ActionTest >> withServerDo: aBlock [

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
