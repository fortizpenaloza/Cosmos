Class {
	#name : #ActionManagementSystemUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'evaluateAction'
	],
	#category : 'Cosmos-Actions-Tests-SystemModel'
}

{ #category : #history }
ActionManagementSystemUserStoryTest class >> lastStoredRun [
	^ ((Dictionary new) add: (#timeStamp->(DateAndTime basicNew instVarAt: 1 put: 6510; instVarAt: 2 put: (Duration seconds: -10800 nanoSeconds: 0); instVarAt: 3 put: 2458339; instVarAt: 4 put: 646306000; yourself)); add: (#passed->((Set new) add: #testActionEvaluation; add: #testQueringRegisteredActions; add: #testRegistrationFailsWhenActionAlreadyExists; add: #testDeregistration; yourself)); add: (#failures->((Set new) add: #testRegistration; yourself)); add: (#errors->((Set new))); yourself)
]

{ #category : #initialization }
ActionManagementSystemUserStoryTest >> setUp [

	super setUp.
	evaluateAction := false
]

{ #category : #initialization }
ActionManagementSystemUserStoryTest >> setUpRequirements [

	super
		setUpRequirements;
		requireActionManagementSystem.

]

{ #category : #tests }
ActionManagementSystemUserStoryTest >> testActionEvaluation [

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
]

{ #category : #tests }
ActionManagementSystemUserStoryTest >> testDeregistration [

	| action |

	action := self actionManagementSystem
		registerNamed: 'Send YO to Fran'
		toEvaluate: [ "empty" ].

	self
		assert: self actionManagementSystem actions
		hasTheSameElementsInTheSameOrderThat: {action}.

	self actionManagementSystem deregisterNamed: 'Send YO to Fran'.

	self assert: self actionManagementSystem actions isEmpty
]

{ #category : #tests }
ActionManagementSystemUserStoryTest >> testQueringRegisteredActions [

	| action anotherAction |

	action := self actionManagementSystem
		registerNamed: 'Send YO to Fran'
		toEvaluate: [ "empty" ].

	anotherAction := self actionManagementSystem
		registerNamed: 'Send text message to Fran'
		toEvaluate: [ "empty" ].

	self
		assert: self actionManagementSystem actions
		hasTheSameElementsInTheSameOrderThat: {action. anotherAction }.

]

{ #category : #tests }
ActionManagementSystemUserStoryTest >> testRegistration [

	| action |

	action := self actionManagementSystem
		registerNamed: 'Send YO to Fran'
		toEvaluate: [ "empty" ].

	self
		assert: action name equals: 'Send YO to Fran';
		assert: action creationDateTime equals: self systemDateTime
]

{ #category : #tests }
ActionManagementSystemUserStoryTest >> testRegistrationFailsWhenActionAlreadyExists [

	| action |

	action := self actionManagementSystem
		registerNamed: 'Send YO to Fran'
		toEvaluate: [ "empty" ].

	self
		should: [ action := self actionManagementSystem
				registerNamed: 'Send YO to Fran'
				toEvaluate: [ "empty" ] ]
		raise: ConflictingObjectFound
		withDescription: 'An action with that name already exists in system'
]
