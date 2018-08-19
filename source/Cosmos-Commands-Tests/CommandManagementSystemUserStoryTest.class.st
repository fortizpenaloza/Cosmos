Class {
	#name : #CommandManagementSystemUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'Cosmos-Commands-Tests'
}

{ #category : #running }
CommandManagementSystemUserStoryTest >> setUpRequirements [

	super
		setUpRequirements;
		requireCommandManagementSystem.

]

{ #category : #tests }
CommandManagementSystemUserStoryTest >> testDeregistering [

	| turnOnLedWithMediumPriority turnOnLedWithHighPriority |

	turnOnLedWithHighPriority := self turnOnLedWithHighPriority.
	self commandManagementSystem register: turnOnLedWithHighPriority.

	turnOnLedWithMediumPriority := self turnOnLedWithMediumPriority.
	self commandManagementSystem register: turnOnLedWithMediumPriority.

	self assert: self commandManagementSystem commands size equals: 2.

	self commandManagementSystem deregister: turnOnLedWithMediumPriority.

	self
		withTheOnlyOneIn: self commandManagementSystem commands
		do:
			[ :commandWithPriority | self assert: commandWithPriority equals: turnOnLedWithHighPriority ]
]

{ #category : #tests }
CommandManagementSystemUserStoryTest >> testNexCommandFollowsPriorities [

	| turnLedOnWithMediumPriority turnLedOnWithLowestPriority turnLedOnWithHighestPriority |

	turnLedOnWithMediumPriority := self turnOnLedWithMediumPriority.
	self commandManagementSystem register: turnLedOnWithMediumPriority.

	turnLedOnWithLowestPriority := self turnOnLedWithLowPriority.
	self commandManagementSystem register: turnLedOnWithLowestPriority.

	turnLedOnWithHighestPriority := self turnOnLedWithHighPriority.
	self commandManagementSystem register: turnLedOnWithHighestPriority.

	self
		assert: self commandManagementSystem nextCommand
			equals: turnLedOnWithHighestPriority;
		assert: self commandManagementSystem nextCommand
			equals: turnLedOnWithMediumPriority;
		assert: self commandManagementSystem nextCommand
			equals: turnLedOnWithLowestPriority
]

{ #category : #tests }
CommandManagementSystemUserStoryTest >> testNextCommandsFailsOnEmptyCommands [

	self assert: self commandManagementSystem commands isEmpty.

	self
		should:
			[ self commandManagementSystem nextCommand ]
		raise: CollectionIsEmpty 
		withDescription: 'Command priority queue is empty'
]

{ #category : #tests }
CommandManagementSystemUserStoryTest >> testQueryingCommands [

	| turnOnLedWithMediumPriority turnOnLedWithLowPriority turnOnLedWithHighPriority |

	turnOnLedWithMediumPriority := self turnOnLedWithMediumPriority.
	self commandManagementSystem register: turnOnLedWithMediumPriority.

	turnOnLedWithLowPriority := self turnOnLedWithLowPriority.
	self commandManagementSystem register: turnOnLedWithLowPriority.

	turnOnLedWithHighPriority := self turnOnLedWithHighPriority.
	self commandManagementSystem register: turnOnLedWithHighPriority.

	self
		assert: self commandManagementSystem commands
		hasTheSameElementsInTheSameOrderThat:
			(OrderedCollection
				with: turnOnLedWithMediumPriority
				with: turnOnLedWithLowPriority
				with: turnOnLedWithHighPriority)
]

{ #category : #tests }
CommandManagementSystemUserStoryTest >> testRegisteredMetadataOnCommandRegistration [

	| commandWithPriority metadata |

	commandWithPriority := self turnOnLedWithHighPriority.

	self assert: (self metadataSystem metadataFor: commandWithPriority) isEmpty.
	self commandManagementSystem register: commandWithPriority.

	metadata := self metadataSystem metadataFor: commandWithPriority.
	self
		assert: metadata size equals: 2;
		assert: metadata
			equals:
			{(Metadata attaching: self currentIdentifier as: #identifier of: commandWithPriority).
			(Metadata
				attaching: self systemDateTime
				as: #registration_timestamp
				of: commandWithPriority)} asOrderedCollection
]

{ #category : #tests }
CommandManagementSystemUserStoryTest >> testRegisteringCommands [

	| turnOnLedWithHighPriority |

	self assert: self commandManagementSystem commands isEmpty.

	turnOnLedWithHighPriority := self turnOnLedWithHighPriority.
	self commandManagementSystem register: turnOnLedWithHighPriority.

	self
		withTheOnlyOneIn: self commandManagementSystem commands
		do:
			[ :commandWithPriority | self assert: commandWithPriority equals: turnOnLedWithHighPriority ]
]

{ #category : #accessing }
CommandManagementSystemUserStoryTest >> turnOffLedCommand [

	^ LEDCommandsAddOn turnOffLedCommand
]

{ #category : #accessing }
CommandManagementSystemUserStoryTest >> turnOnLedCommand [

	^ LEDCommandsAddOn turnOnLedCommand
]

{ #category : #accessing }
CommandManagementSystemUserStoryTest >> turnOnLedWithHighPriority [

	^ CommandWithPriority holding: self turnOnLedCommand and: 100
]

{ #category : #accessing }
CommandManagementSystemUserStoryTest >> turnOnLedWithLowPriority [

	^ CommandWithPriority holding: self turnOnLedCommand and: 1
]

{ #category : #accessing }
CommandManagementSystemUserStoryTest >> turnOnLedWithMediumPriority [

	^ CommandWithPriority holding: self turnOnLedCommand and: 50
]
