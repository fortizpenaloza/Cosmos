"
I evaluate Actions.

I asycroniulsy take actions from a shared queue and after evaluation y register them back with it's evaluation timestamp into another queue.
"
Class {
	#name : #ActionEvaluator,
	#superclass : #Object,
	#instVars : [
		'configuration',
		'actionEvaluationsQueue',
		'pendingActionsDequeuingProcess'
	],
	#category : #'Cosmos-ActionEvaluator'
}

{ #category : #'instance creation' }
ActionEvaluator class >> evaluatingActionsFrom: aPendingActionsQueue using: aConfiguration registeringEvaluationsInto: anActionEvaluationsQueue [

	^ self new
		initializeEvaluatingActionsFrom: aPendingActionsQueue
		using: aConfiguration
		registeringEvaluationsInto: anActionEvaluationsQueue
]

{ #category : #'private - accessing' }
ActionEvaluator >> dateTime [

	^ configuration dateTime
]

{ #category : #evaluating }
ActionEvaluator >> evaluate: anAction [

	anAction evaluateWithin: configuration.
	actionEvaluationsQueue
		enqueue: (ActionEvaluation of: anAction on: self dateTime)
]

{ #category : #initialization }
ActionEvaluator >> initializeEvaluatingActionsFrom: aPendingActionsQueue using: aConfiguration registeringEvaluationsInto: anActionEvaluationsQueue [

	configuration := aConfiguration.
	pendingActionsDequeuingProcess := DequeuingProcess
		named: 'Pending actions dequeuing process'
		from: aPendingActionsQueue
		applying: [ :action | self evaluate: action ].

	actionEvaluationsQueue := anActionEvaluationsQueue
]

{ #category : #controlling }
ActionEvaluator >> start [

	pendingActionsDequeuingProcess start
]

{ #category : #controlling }
ActionEvaluator >> stop [

	pendingActionsDequeuingProcess stop
]
