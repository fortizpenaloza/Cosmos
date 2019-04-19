Class {
	#name : #ActionEvaluationSystemUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'actionEvaluations'
	],
	#category : #'Cosmos-ActionEvaluation-Tests'
}

{ #category : #systems }
ActionEvaluationSystemUserStoryTest >> actionEvaluationSystem [
	
	^ rootSystem >> #ActionEvaluationSystemInterface
]

{ #category : #accessing }
ActionEvaluationSystemUserStoryTest >> octoberFirstOf2014AtNoon [

	^ (October first , 2014) atNoon
]

{ #category : #accessing }
ActionEvaluationSystemUserStoryTest >> sendTextMessageToFran [

	^ Action
		named: 'Send text message to Fran'
		evaluating: [ "do nothing" ]
]

{ #category : #accessing }
ActionEvaluationSystemUserStoryTest >> sendYOToFran [

	^ Action named: 'Send YO to Fran' evaluating: [ "Send YO to Fran" ]
]

{ #category : #running }
ActionEvaluationSystemUserStoryTest >> setUp [

	actionEvaluations := AtomicSharedQueue new.
	super setUp
]

{ #category : #'private - running' }
ActionEvaluationSystemUserStoryTest >> setUpRequirements [

	self
		registerSubsystem: (ActionEvaluationSystem registeringFrom: actionEvaluations)
]

{ #category : #running }
ActionEvaluationSystemUserStoryTest >> tearDown [ 

	rootSystem shutDown  
]

{ #category : #tests }
ActionEvaluationSystemUserStoryTest >> testQueringActionEvaluationSummaries [

	| action |

	action := self sendYOToFran.
	actionEvaluations
		enqueue: (ActionEvaluation of: action on: self octoberFirstOf2014AtNoon).

	self
		assert: self actionEvaluationSystem actionEvaluationSummaries isEmpty.

	(Delay forDuration: 10 milliSeconds) wait. 
	
	self
		withTheOnlyOneIn: self actionEvaluationSystem actionEvaluationSummaries
		do: [ :summary | 
			self
				assert: summary action equals: action;
				assert: summary lastEvaluation
					equals: self octoberFirstOf2014AtNoon;
				assert: summary evaluationCount equals: 1 ]
]
