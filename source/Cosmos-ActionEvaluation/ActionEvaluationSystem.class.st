Class {
	#name : #ActionEvaluationSystem,
	#superclass : #SubsystemImplementation,
	#instVars : [
		'evaluationSummaries',
		'dequeuingProcess',
		'actionEvaluations',
		'pendingEvaluationActions',
		'actionEvaluationQueue'
	],
	#category : #'Cosmos-ActionEvaluation'
}

{ #category : #'instance creation' }
ActionEvaluationSystem class >> registeringAll: anActionEvaluationCollection addingPendingActionsTo: anActionCollection [

	^ self new initializeRegisteringAll: anActionEvaluationCollection
]

{ #category : #managing }
ActionEvaluationSystem >> actionEvaluationSummaries [
	
	^ evaluationSummaries values
]

{ #category : #installing }
ActionEvaluationSystem >> dependencies [

	^ #()
]

{ #category : #accessing }
ActionEvaluationSystem >> dequeuingProcess [

	[ | nextActionEvaluation |

	[ nextActionEvaluation := actionEvaluationQueue dequeue ]
		whileNotNil: [ self register: nextActionEvaluation ] ] repeat
]

{ #category : #evaluating }
ActionEvaluationSystem >> evaluate: anAction [ 
	
	pendingEvaluationActions enqueue: anAction
]

{ #category : #installing }
ActionEvaluationSystem >> implementedInterfaces [

	^ #(#ActionEvaluationSystemInterface)
]

{ #category : #initialization }
ActionEvaluationSystem >> initializeDequeuingProcess [

	dequeuingProcess := [ self dequeuingProcess ] newProcess.

	dequeuingProcess
		name: 'Action evaluation dequeuing process';
		priority: Processor userBackgroundPriority + 1
]

{ #category : #initialization }
ActionEvaluationSystem >> initializeRegisteringAll: anActionEvaluationCollection [

	self initialize.

	self flag: 'borrar la primera y renombrar la segunda, es un proceso'.
	actionEvaluationQueue := anActionEvaluationCollection.

	actionEvaluations := OrderedCollection new.
	evaluationSummaries := Dictionary new.
	
	self initializeDequeuingProcess
]

{ #category : #accessing }
ActionEvaluationSystem >> name [

	^ 'Action Evaluation'
]

{ #category : #managing }
ActionEvaluationSystem >> register: anActionEvaluation [

	actionEvaluations add: anActionEvaluation.

	evaluationSummaries
		at: anActionEvaluation action 
		ifPresent:
			[ :summary | summary registerEvaluationOn: anActionEvaluation evaluationDateTime ]
		ifAbsentPut:
			(ActionEvaluationSummary
				of: anActionEvaluation action
				lastEvaluatedOn: anActionEvaluation evaluationDateTime
				totaling: 1)
]

{ #category : #'private - controlling' }
ActionEvaluationSystem >> shutDownWhenStarted [

	super shutDownWhenStarted.
	dequeuingProcess terminate
]

{ #category : #'private - controlling' }
ActionEvaluationSystem >> startUpWhenStopped [

	super startUpWhenStopped
]
