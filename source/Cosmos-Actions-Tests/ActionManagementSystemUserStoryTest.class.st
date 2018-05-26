Class {
	#name : #ActionManagementSystemUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'evaluateAction'
	],
	#category : 'Cosmos-Actions-Tests-SystemModel'
}

{ #category : #accessing }
ActionManagementSystemUserStoryTest >> septemberSixth2015AtNoon [

	^ (September sixth, 2015) atNoon
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
		assert: action creationDateTime equals: self septemberSixth2015AtNoon
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
		raise: ObjectAlreadyInSystem
		withDescription: 'An action with that name already exists in system'
]
