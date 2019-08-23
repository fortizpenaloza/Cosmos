Class {
	#name : #ActionEvaluationSystem,
	#superclass : #SubsystemImplementation,
	#instVars : [
		'actionEvaluations',
		'actionEvaluationsDequeuingProcess',
		'actionEvaluationSummaries'
	],
	#category : #'Cosmos-ActionEvaluation'
}

{ #category : #'instance creation' }
ActionEvaluationSystem class >> registeringFrom: anActionEvaluationsQueue [

	^ self new initializeRegisteringFrom: anActionEvaluationsQueue
]

{ #category : #querying }
ActionEvaluationSystem >> actionEvaluationSummaries [
	
	^ actionEvaluationSummaries values
]

{ #category : #querying }
ActionEvaluationSystem >> actionEvaluations [

	^ actionEvaluations copy 
]

{ #category : #installing }
ActionEvaluationSystem >> dependencies [

	^ #()
]

{ #category : #installing }
ActionEvaluationSystem >> implementedInterfaces [

	^ #(#ActionEvaluationSystemInterface)
]

{ #category : #initialization }
ActionEvaluationSystem >> initializeDequeuingProcessFrom: anActionEvaluationQueue [

	actionEvaluationsDequeuingProcess := DequeuingProcess
		named: 'Action evaluation dequeuing'
		from: anActionEvaluationQueue
		applying: [ :actionEvaluation | self register: actionEvaluation ]
]

{ #category : #initialization }
ActionEvaluationSystem >> initializeRegisteringFrom: anActionEvaluationsQueue [

	self initialize.
	self initializeDequeuingProcessFrom: anActionEvaluationsQueue.

	actionEvaluations := OrderedCollection new.
	actionEvaluationSummaries := Dictionary new
]

{ #category : #'private - managing' }
ActionEvaluationSystem >> initializeSummaryFor: anActionEvaluation [

	^ ActionEvaluationSummary of: anActionEvaluation 
]

{ #category : #accessing }
ActionEvaluationSystem >> name [

	^ 'Action Evaluation'
]

{ #category : #managing }
ActionEvaluationSystem >> register: anActionEvaluation [

	actionEvaluations add: anActionEvaluation.
	self registerToSummary: anActionEvaluation
]

{ #category : #'private - managing' }
ActionEvaluationSystem >> registerToSummary: anActionEvaluation [

	actionEvaluationSummaries
		at: anActionEvaluation action
		ifPresent:
			[ :summary | summary synchronizeWith: anActionEvaluation ]
		ifAbsentPut: [ self initializeSummaryFor: anActionEvaluation ]
]

{ #category : #'private - controlling' }
ActionEvaluationSystem >> shutDownWhenStarted [

	super shutDownWhenStarted.
	actionEvaluationsDequeuingProcess stop
]

{ #category : #'private - controlling' }
ActionEvaluationSystem >> startUpWhenStopped [

	super startUpWhenStopped.
	actionEvaluationsDequeuingProcess start
]
