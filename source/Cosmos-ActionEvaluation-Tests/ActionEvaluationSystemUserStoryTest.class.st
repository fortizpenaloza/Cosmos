Class {
	#name : #ActionEvaluationSystemUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'actionEvaluationsQueue'
	],
	#category : #'Cosmos-ActionEvaluation-Tests'
}

{ #category : #'private - systems' }
ActionEvaluationSystemUserStoryTest >> actionEvaluationSystem [
	
	^ rootSystem >> #ActionEvaluationSystemInterface
]

{ #category : #'private - accessing' }
ActionEvaluationSystemUserStoryTest >> octoberFirstOf2014AtNoon [

	^ (October first , 2014) atNoon
]

{ #category : #'private - accessing' }
ActionEvaluationSystemUserStoryTest >> sendYOToFran [

	^ Action named: 'Send YO to Fran' evaluating: [ "Send YO to Fran" ]
]

{ #category : #running }
ActionEvaluationSystemUserStoryTest >> setUp [

	actionEvaluationsQueue := AtomicSharedQueue new.
	super setUp
]

{ #category : #'private - running' }
ActionEvaluationSystemUserStoryTest >> setUpRequirements [

	self
		registerSubsystem: (ActionEvaluationSystem registeringFrom: actionEvaluationsQueue)
]

{ #category : #running }
ActionEvaluationSystemUserStoryTest >> tearDown [ 

	rootSystem shutDown  
]

{ #category : #tests }
ActionEvaluationSystemUserStoryTest >> testAccessing [

	self
		assert: self actionEvaluationSystem name
		equals: 'Action Evaluation'
]

{ #category : #tests }
ActionEvaluationSystemUserStoryTest >> testQueringActionEvaluationSummaries [

	| action |

	action := self sendYOToFran.
	actionEvaluationsQueue
		enqueue: (ActionEvaluation of: action on: self octoberFirstOf2014AtNoon).

	self
		assert: self actionEvaluationSystem actionEvaluationSummaries isEmpty.

	self
		wait: 10 milliSeconds
		andDo: [ self
				withTheOnlyOneIn: self actionEvaluationSystem actionEvaluationSummaries
				do: [ :summary | 
					self
						assert: summary action equals: action;
						assert: summary lastEvaluation
							equals: self octoberFirstOf2014AtNoon;
						assert: summary evaluationCount equals: 1 ] ]
]

{ #category : #'tests support' }
ActionEvaluationSystemUserStoryTest >> wait: aDuration andDo: aBlock [

	(Delay forDuration: aDuration) wait.
	aBlock value
]
