Class {
	#name : #ActionEvaluationSummaryTest,
	#superclass : #TestCase,
	#category : #'Cosmos-ActionEvaluation-Tests'
}

{ #category : #accessing }
ActionEvaluationSummaryTest >> doNothing [

	^ Action named: 'Do nothing' evaluating: [ "do nothing" ]
]

{ #category : #accessing }
ActionEvaluationSummaryTest >> doNothingOnOctoberFirstOf2014AtNoon [

	^ ActionEvaluation
		of: self doNothing
		on: self octoberFirstOf2014AtNoon
]

{ #category : #accessing }
ActionEvaluationSummaryTest >> doNothingOnOctoberThirdOf2014AtMidnight [

	^ ActionEvaluation
		of: self doNothing
		on: self octoberThirdOf2014AtMidnight
]

{ #category : #accessing }
ActionEvaluationSummaryTest >> octoberFirstOf2014AtNoon [

	^ (October first , 2014) atNoon
]

{ #category : #accessing }
ActionEvaluationSummaryTest >> octoberThirdOf2014AtMidnight [

	^ (October third , 2014) atMidnight
]

{ #category : #tests }
ActionEvaluationSummaryTest >> testInstanceCreationAndAccessing [

	| summary |

	summary := ActionEvaluationSummary
		of: self doNothingOnOctoberFirstOf2014AtNoon.

	self
		assert: summary action equals: self doNothing;
		assert: summary lastEvaluation
			equals: self octoberFirstOf2014AtNoon;
		assert: summary evaluationCount equals: 1
]

{ #category : #tests }
ActionEvaluationSummaryTest >> testUpdate [

	| summary |

	summary := ActionEvaluationSummary
		of: self doNothingOnOctoberFirstOf2014AtNoon.

	self
		assert: summary action equals: self doNothing;
		assert: summary lastEvaluation
			equals: self octoberFirstOf2014AtNoon;
		assert: summary evaluationCount equals: 1.

	summary synchronizeWith: self doNothingOnOctoberThirdOf2014AtMidnight.

	self
		assert: summary action equals: self doNothing;
		assert: summary lastEvaluation
			equals: self octoberThirdOf2014AtMidnight;
		assert: summary evaluationCount equals: 2
]

{ #category : #tests }
ActionEvaluationSummaryTest >> testUpdatingFailsIfActionDoesNotMatch [

	| summary |

	summary := ActionEvaluationSummary
		of: self doNothingOnOctoberFirstOf2014AtNoon.

	self
		assert: summary action equals: self doNothing;
		assert: summary lastEvaluation
			equals: self octoberFirstOf2014AtNoon;
		assert: summary evaluationCount equals: 1.

	self
		should: [ summary
				synchronizeWith:
					(ActionEvaluation
						of: self wrongAction
						on: self octoberThirdOf2014AtMidnight) ]
		raise: ConflictingObjectFound.

	self
		assert: summary action equals: self doNothing;
		assert: summary lastEvaluation
			equals: self octoberFirstOf2014AtNoon;
		assert: summary evaluationCount equals: 1
]

{ #category : #accessing }
ActionEvaluationSummaryTest >> wrongAction [

	^ Action named: 'Wrong action' evaluating: [ "do nothing" ]
]
