Class {
	#name : #PeriodicalSchedulerTest,
	#superclass : #TestCase,
	#category : 'Cosmos-PeriodicalScheduler-Tests'
}

{ #category : #accessing }
PeriodicalSchedulerTest >> tenMinutes [
	
	^ TimeUnits minute with: 10
]

{ #category : #tests }
PeriodicalSchedulerTest >> testSchedulingChangeBooleanValueTask [

	| wasExecuted task scheduler |

	wasExecuted := false.
	task := Task named: 'Change wasExecuted value to true' do: [ wasExecuted := true ].

	scheduler := PeriodicalScheduler workingWith: DelayNullScheduler new.
	scheduler schedule: task toBeExecutedEvery: self tenMinutes.
	self deny: wasExecuted.

	scheduler start.
	(Delay forSeconds: 4) wait.
	self assert: wasExecuted.

	scheduler stop
]
