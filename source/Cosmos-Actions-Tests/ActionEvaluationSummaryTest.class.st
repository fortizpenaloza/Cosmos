Class {
	#name : #ActionEvaluationSummaryTest,
	#superclass : #TestCase,
	#category : #'Cosmos-Actions-Tests'
}

{ #category : #tests }
ActionEvaluationSummaryTest >> doNothing [

	^ Action named: 'Do nothing' evaluating: [ "do nothing" ]
]

{ #category : #accessing }
ActionEvaluationSummaryTest >> octoberFirstOf2014AtNoon [

	^ (October first , 2014) atNoon
]

{ #category : #tests }
ActionEvaluationSummaryTest >> testInstanceCreationAndAccessing [

	| summary |

	summary := ActionEvaluationSummary
		of: self doNothing
		lastEvaluatedOn: self octoberFirstOf2014AtNoon
		totaling: 1.
		
	self
		assert: summary action equals: self doNothing;
		assert: summary lastEvaluation
			equals: self octoberFirstOf2014AtNoon;
		assert: summary evaluationCount equals: 1
]

{ #category : #tests }
ActionEvaluationSummaryTest >> testRegisterEvaluation [

	| summary |

	summary := ActionEvaluationSummary
		of: self doNothing
		lastEvaluatedOn: self octoberFirstOf2014AtNoon
		totaling: 1.

	self
		assert: summary action equals: self doNothing;
		assert: summary lastEvaluation
			equals: self octoberFirstOf2014AtNoon;
		assert: summary evaluationCount equals: 1.

	summary registerEvaluationOn: (December third , 2014) atMidnight.

	self
		assert: summary action equals: self doNothing;
		assert: summary lastEvaluation
			equals: (December third , 2014) atMidnight;
		assert: summary evaluationCount equals: 2
]
