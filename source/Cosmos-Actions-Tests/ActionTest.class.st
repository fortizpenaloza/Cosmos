Class {
	#name : #ActionTest,
	#superclass : #TestCase,
	#category : 'Cosmos-Actions-Tests-Model'
}

{ #category : #tests }
ActionTest >> testInstanceCreationAndAccessing [

	| action |

	action := Action
		named: 'Do nothing'
		evaluating: (EvaluateBlockPolicy for: [ "do nothing" ]).

	self
		assert: action name equals: 'Do nothing'
]
