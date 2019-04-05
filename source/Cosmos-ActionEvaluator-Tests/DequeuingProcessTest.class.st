Class {
	#name : #DequeuingProcessTest,
	#superclass : #TestCase,
	#instVars : [
		'wasDequeued',
		'queue'
	],
	#category : #'Cosmos-ActionEvaluator-Tests'
}

{ #category : #running }
DequeuingProcessTest >> setUp [
	
	wasDequeued := false.
	queue := AtomicSharedQueue new.
]

{ #category : #tests }
DequeuingProcessTest >> test01 [

	| dequeuingProcess |

	self assert: queue isEmpty.
	queue nextPut: 1.
	self deny: queue isEmpty.
	dequeuingProcess := DequeuingProcess
		named: 'Test process'
		from: queue
		applying: [ :element | wasDequeued := true ].

	self
		deny: queue isEmpty;
		deny: wasDequeued.

	[ dequeuingProcess start.
	(Delay forDuration: 10 milliSeconds) wait.
	self
		assert: queue isEmpty;
		assert: wasDequeued ]
		ensure: [ dequeuingProcess stop ]
]
