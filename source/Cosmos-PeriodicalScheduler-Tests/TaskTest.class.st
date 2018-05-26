Class {
	#name : #TaskTest,
	#superclass : #TestCase,
	#category : 'Cosmos-PeriodicalScheduler-Tests'
}

{ #category : #tests }
TaskTest >> testExecution [

	| wasExecuted task |
	
	wasExecuted := false.
	task := Task named: 'Change boolean to true' do: [ wasExecuted := true ].
	self deny: wasExecuted.
	
	task execute.
	self assert: wasExecuted
]

{ #category : #tests }
TaskTest >> testInstanceCreationAndAccessing [

	| wasExecuted task |
	
	wasExecuted := false.
	task := Task named: 'Change boolean to true' do: [ wasExecuted := true ].
	
	self assert: task name equals: 'Change boolean to true'.
	self deny: wasExecuted
]
