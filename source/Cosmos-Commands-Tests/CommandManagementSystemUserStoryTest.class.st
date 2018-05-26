Class {
	#name : #CommandManagementSystemUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#category : 'Cosmos-Commands-Tests-SystemModel'
}

{ #category : #running }
CommandManagementSystemUserStoryTest >> setUpRequirements [

	super
		setUpRequirements;
		requireCommandManagementSystem.

]

{ #category : #tests }
CommandManagementSystemUserStoryTest >> testDequeuingCommandsFollowsItsPriority [

	self commandManagementSystem enqueue: self turnOnLedCommand with: QueuePriority medium.
	self commandManagementSystem enqueue: self turnOnLedCommand with: QueuePriority low.
	self commandManagementSystem enqueue: self turnOffLedCommand with: QueuePriority high.

	self
		assert: self commandManagementSystem dequeue
		equals:
			(PrioritizedCommand
				holding: self turnOffLedCommand
				with: QueuePriority high
				on: self timeSystem dateTime).
	self
		assert: self commandManagementSystem dequeue
		equals:
			(PrioritizedCommand
				holding: self turnOnLedCommand
				with: QueuePriority medium
				on: self timeSystem dateTime).
	self
		assert: self commandManagementSystem dequeue
		equals:
			(PrioritizedCommand
				holding: self turnOnLedCommand
				with: QueuePriority low
				on: self timeSystem dateTime)
]

{ #category : #tests }
CommandManagementSystemUserStoryTest >> testDequeuingFromQueueFailsIfEmpty [

	self
		should:
			[ self commandManagementSystem dequeue ]
		raise: QueueIsEmpty
		withDescription: 'Command priority queue is empty'
]

{ #category : #tests }
CommandManagementSystemUserStoryTest >> testEnqueuingAndThenDequeuingCommand [

	self commandManagementSystem
		enqueue: self turnOnLedCommand
		with: QueuePriority high.

	self
		assert: self commandManagementSystem dequeue
		equals:
			(PrioritizedCommand
				holding: self turnOnLedCommand
				with: QueuePriority high
				on: self timeSystem dateTime)
]

{ #category : #tests }
CommandManagementSystemUserStoryTest >> testQueryingPrioritizedCommands [

	self commandManagementSystem
		enqueue: self turnOnLedCommand
		with: QueuePriority high.
	self commandManagementSystem
		enqueue: self turnOffLedCommand
		with: QueuePriority medium.

	self
		assert:
			(self commandManagementSystem
				prioritizedCommands)
		hasTheSameElementsInTheSameOrderThat:
			(OrderedCollection
				with:
					(PrioritizedCommand
						holding: self turnOnLedCommand
						with: QueuePriority high
						on: self timeSystem dateTime)
				with:
					(PrioritizedCommand
						holding: self turnOffLedCommand
						with: QueuePriority medium
						on: self timeSystem dateTime))
]

{ #category : #accessing }
CommandManagementSystemUserStoryTest >> turnOffLedCommand [

	^ LEDCommandsAddOn turnOffLedCommand
]

{ #category : #accessing }
CommandManagementSystemUserStoryTest >> turnOnLedCommand [

	^ LEDCommandsAddOn turnOnLedCommand
]
