Class {
	#name : #ActionEvaluationSystemUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'evaluatedActions',
		'pendingEvaluationActions',
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

	pendingEvaluationActions := WaitfreeQueue new.
	actionEvaluations := WaitfreeQueue new.

	super setUp
]

{ #category : #'private - running' }
ActionEvaluationSystemUserStoryTest >> setUpRequirements [

	self
		registerSubsystem:
			(ActionEvaluationSystem
				registeringAll: actionEvaluations
				addingPendingActionsTo: pendingEvaluationActions)
]

{ #category : #running }
ActionEvaluationSystemUserStoryTest >> tearDown [ 

	rootSystem shutDown  
]

{ #category : #tests }
ActionEvaluationSystemUserStoryTest >> testQueringActionEvaluationSummaries [

	| action anotherAction |

	action := self sendYOToFran.
	self actionEvaluationSystem evaluate: action.

	anotherAction := self sendTextMessageToFran.
	self actionEvaluationSystem evaluate: anotherAction.

	self
		assert: pendingEvaluationActions size equals: 2;
		assert: self actionEvaluationSystem actionEvaluationSummaries isEmpty.

	self actionEvaluationSystem
		register: (ActionEvaluation of: action on: self octoberFirstOf2014AtNoon).

	self
		withTheOnlyOneIn: self actionEvaluationSystem actionEvaluationSummaries
		do: [ :summary | 
			self
				assert: summary action equals: action;
				assert: summary lastEvaluation
					equals: self octoberFirstOf2014AtNoon;
				assert: summary evaluationCount equals: 1 ]
]
