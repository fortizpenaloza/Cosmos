Class {
	#name : #ActionManagementSystemUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'Cosmos-Actions-Tests-SystemModel'
}

{ #category : #initialization }
ActionManagementSystemUserStoryTest >> setUpRequirements [

	super
		setUpRequirements;
		requireActionManagementSystem.

]

{ #category : #tests }
ActionManagementSystemUserStoryTest >> testDeregistration [

	| action |

	action := Action
		named: 'Send YO to Fran'
		evaluating: (EvaluateBlockPolicy for: [ "do nothing" ]).

	self actionManagementSystem register: action.

	self
		assert: self actionManagementSystem actions
		hasTheSameElementsInTheSameOrderThat: {action}.

	self actionManagementSystem deregister: action.

	self assert: self actionManagementSystem actions isEmpty
]

{ #category : #tests }
ActionManagementSystemUserStoryTest >> testDeregistrationFailsIfNotExists [

	| action |

	action := Action
		named: 'Send YO to Fran'
		evaluating: (EvaluateBlockPolicy for: [ "do nothing" ]).

	self
		should: [ self actionManagementSystem deregister: action ]
		raise: NotFound.
]

{ #category : #tests }
ActionManagementSystemUserStoryTest >> testQueringRegisteredActions [

	| action anotherAction |

	action := Action
		named: 'Send YO to Fran'
		evaluating: (EvaluateBlockPolicy for: [ "empty" ]).

	self actionManagementSystem register: action.

	anotherAction := Action
		named: 'Send text message to Fran'
		evaluating: (EvaluateBlockPolicy for: [ "empty" ]).

	self actionManagementSystem register: anotherAction.

	self
		assert: self actionManagementSystem actions
		hasTheSameElementsInTheSameOrderThat:
			{action.
			anotherAction}
]

{ #category : #tests }
ActionManagementSystemUserStoryTest >> testRegistration [

	| action |

	self assert: self actionManagementSystem actions isEmpty.

	action := Action
		named: 'Send YO to Fran'
		evaluating: (EvaluateBlockPolicy for: [ "do nothing" ]).

	action := self actionManagementSystem register: action.

	self
		withTheOnlyOneIn: self actionManagementSystem actions
		do: [ :onlyAction | self assert: onlyAction name equals: 'Send YO to Fran' ]
]

{ #category : #tests }
ActionManagementSystemUserStoryTest >> testRegistrationFailsWhenActionAlreadyExists [

	| action |

	action := Action named: 'Send YO to Fran' evaluating: [ "empty" ].
	self actionManagementSystem register: action.
	self
		should: [ self actionManagementSystem register: action ]
		raise: ConflictingObjectFound
		withDescription: 'An action with that name already exists in system'
]
