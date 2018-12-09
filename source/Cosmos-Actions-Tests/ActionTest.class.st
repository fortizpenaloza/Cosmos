Class {
	#name : #ActionTest,
	#superclass : #TestCase,
	#category : #'Cosmos-Actions-Tests'
}

{ #category : #tests }
ActionTest >> testHash [

	| action equivalentAction differentAction |

	action := Action
		named: 'Do nothing'
		evaluating: (EvaluateBlockPolicy for: [ "do nothing" ]).

	equivalentAction := Action
		named: 'Do nothing'
		evaluating: (EvaluateBlockPolicy for: [ "do nothing" ]).

	differentAction := Action
		named: 'Do something'
		evaluating: (EvaluateBlockPolicy for: [ "do something" ]).

	self
		assert: action hash equals: equivalentAction hash;
		deny: action hash = differentAction hash
]

{ #category : #tests }
ActionTest >> testInstanceCreationAndAccessing [

	| action |

	action := Action
		named: 'Do nothing'
		evaluating: (EvaluateBlockPolicy for: [ "do nothing" ]).

	self
		assert: action name equals: 'Do nothing'
]
