"
A ScheduledTaskTest is a test class for testing the behavior of ScheduledTask
"
Class {
	#name : #ScheduledTaskTest,
	#superclass : #TestCase,
	#category : 'Cosmos-PeriodicalScheduler-Tests'
}

{ #category : #accessing }
ScheduledTaskTest >> oneMinute [

	^ TimeUnits minute with: 1
]

{ #category : #tests }
ScheduledTaskTest >> testExecution [

	| wasExecuted task scheduledTask |

	wasExecuted := false.
	task := Task named: 'Change boolean to true' do: [ wasExecuted := true ].
	scheduledTask := ScheduledTask executing: task every: self oneMinute.
	self deny: wasExecuted.
	
	scheduledTask execute.
	self assert: wasExecuted
]

{ #category : #tests }
ScheduledTaskTest >> testInstanceCreationAndAccessing [

	| wasExecuted task scheduledTask |

	wasExecuted := false.
	task := Task named: 'Change boolean to true' do: [ wasExecuted := true ].
	scheduledTask := ScheduledTask executing: task every: self oneMinute.

	self
		assert: scheduledTask name equals: 'Change boolean to true';
		assert: scheduledTask timePeriod equals: self oneMinute;
		deny: wasExecuted
]
