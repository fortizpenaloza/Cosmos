Class {
	#name : #ActionTest,
	#superclass : #TestCase,
	#category : 'Cosmos-Actions-Tests-Model'
}

{ #category : #accessing }
ActionTest >> fiveMinutes [

	^ TimeUnits minute with: 5
]

{ #category : #accessing }
ActionTest >> septemberSixth2015AtTwelveOFivePM [

	^ (September sixth , 2015) atNoon next: self fiveMinutes
]

{ #category : #tests }
ActionTest >> testInstanceCreation [

	| action |

	action := Action
		named: 'Do nothing'
		createdOn: self septemberSixth2015AtTwelveOFivePM
		toEvaluate: (BlockEvaluationPolicy for: [ "do nothing" ]).

	self
		assert: action name equals: 'Do nothing';
		assert: action creationDateTime equals: self septemberSixth2015AtTwelveOFivePM
]
