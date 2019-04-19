Class {
	#name : #DequeuingProcessTest,
	#superclass : #TestCase,
	#instVars : [
		'wasDequeued',
		'queue'
	],
	#category : #'Cosmos-ActionEvaluator-Tests'
}

{ #category : #tests }
DequeuingProcessTest >> assertQueueHasOneElement [

	self assert: queue isEmpty.
	queue enqueue: 1.
	self deny: queue isEmpty
]

{ #category : #running }
DequeuingProcessTest >> setUp [
	
	wasDequeued := false.
	queue := AtomicSharedQueue new.
]

{ #category : #tests }
DequeuingProcessTest >> testDequeueing [

	| dequeuingProcess |

	self assertQueueHasOneElement.
	
	dequeuingProcess := DequeuingProcess
		named: 'Test process'
		from: queue
		applying: [ :element | wasDequeued := true ].
	
	self
		deny: queue isEmpty;
		deny: wasDequeued.
	
[ dequeuingProcess start.
	self
		wait: 10 milliSeconds
		andDo: [ self
				assert: queue isEmpty;
				assert: wasDequeued ] ]
		ensure: [ dequeuingProcess stop ]
]

{ #category : #'tests support' }
DequeuingProcessTest >> wait: aDuration andDo: aBlock [

	(Delay forDuration: aDuration) wait.
	aBlock value
]
