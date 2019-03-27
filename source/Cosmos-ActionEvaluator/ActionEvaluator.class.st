"
I evaluate Actions.

I asycroniulsy take actions from a shared queue and after evaluation y register them back with it's evaluation timestamp into another queue.
"
Class {
	#name : #ActionEvaluator,
	#superclass : #Object,
	#instVars : [
		'configuration',
		'evaluatedActions',
		'dequeuingProcess',
		'pendingEvaluationActions'
	],
	#category : #'Cosmos-ActionEvaluator'
}

{ #category : #'instance creation' }
ActionEvaluator class >> evaluatingAll: anActionCollection using: aConfiguration registeringEvaluationsOn: anActionEvaluationCollection [

	^ self new initializeEvaluatingAll: anActionCollection using: aConfiguration registeringEvaluationsOn: anActionEvaluationCollection
]

{ #category : #'private - accessing' }
ActionEvaluator >> dateTime [

	^ configuration dateTime
]

{ #category : #'private - accessing' }
ActionEvaluator >> dequeuingProcess [

	[ | nextAction |

	[ nextAction := pendingEvaluationActions dequeue ]
		whileNotNil: [ self evaluate: nextAction ] ] repeat
]

{ #category : #evaluating }
ActionEvaluator >> evaluate: anAction [

	anAction evaluateWithin: configuration.
	evaluatedActions
		enqueue: (ActionEvaluation of: anAction on: self dateTime)
]

{ #category : #initialization }
ActionEvaluator >> initializeDequeuingProcess [

	dequeuingProcess := [ self dequeuingProcess ] newProcess.

	dequeuingProcess
		name: 'Action dequeuing process';
		priority: Processor userBackgroundPriority + 1
]

{ #category : #initialization }
ActionEvaluator >> initializeEvaluatingAll: anActionCollection using: aConfiguration registeringEvaluationsOn: anActionEvaluationCollection [

	configuration := aConfiguration.
	pendingEvaluationActions := anActionCollection.
	evaluatedActions := anActionEvaluationCollection.
	
	self flag: 'rename to show pendingActions'.
	self initializeDequeuingProcess
]

{ #category : #controlling }
ActionEvaluator >> start [

	dequeuingProcess resume
]

{ #category : #controlling }
ActionEvaluator >> stop [

	dequeuingProcess terminate
]
