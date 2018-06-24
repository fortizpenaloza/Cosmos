Class {
	#name : #CommandsAPITest,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'Cosmos-API-Commands-Tests'
}

{ #category : #running }
CommandsAPITest >> setUp [

	super setUp.
	
	(LEDCommandsAddOn on: rootSystem) install
]

{ #category : #running }
CommandsAPITest >> setUpRequirements [

	super
		setUpRequirements;
		requireCommandManagementSystem.

]

{ #category : #tests }
CommandsAPITest >> testDequeuingCommandFormattedAsJSON [

	| interface response |

	interface := CommandsAPI workingWith: rootSystem.
	response := interface nextCommandAsJSON.

	self assert: response equals: '{
	"command" : "TURN_ON_LED",
	"priority" : "High"
}'
]

{ #category : #tests }
CommandsAPITest >> testDequeuingCommandFormattedAsPlainText [

	| interface response |

	interface := CommandsAPI workingWith: rootSystem.
	response := interface nextCommandAsPlainText.

	self assert: response equals: 'TURN_ON_LED'
]

{ #category : #tests }
CommandsAPITest >> testEnqueuingCommand [

	| interface prioritizedCommand |

	interface := CommandsAPI workingWith: rootSystem.
	prioritizedCommand := interface push: '{
	"command" : "TURN_ON_LED",
	"priority" : "high"
}'.

	self assert: (self commandManagementSystem prioritizedCommands includes: prioritizedCommand)

	
]

{ #category : #tests }
CommandsAPITest >> testQueryingPrioitizedCommands [

	| interface response |

	interface := CommandsAPI workingWith: rootSystem.
	response := interface prioritizedCommands.

	self assert: response equals: '[
	{
		"command" : "TURN_ON_LED",
		"priority" : "High"
	}
]'
]
