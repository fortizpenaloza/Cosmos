Class {
	#name : #RESTCommandsInterfaceTest,
	#superclass : #SystemBasedUserStoryTest,
	#category : 'Cosmos-Commands-API-Tests'
}

{ #category : #running }
RESTCommandsInterfaceTest >> setUp [

	super setUp.
	
	(LEDCommandsAddOn on: rootSystem) install
]

{ #category : #running }
RESTCommandsInterfaceTest >> setUpRequirements [

	super
		setUpRequirements;
		requireCommandManagementSystem.

]

{ #category : #tests }
RESTCommandsInterfaceTest >> testDequeuingCommandFormattedAsJSON [

	| interface response |

	interface := RESTCommandsInterface workingWith: rootSystem.
	response := interface nextCommandAsJSON.

	self assert: response equals: '{
	"command" : "TURN_ON_LED",
	"priority" : "High"
}'
]

{ #category : #tests }
RESTCommandsInterfaceTest >> testDequeuingCommandFormattedAsPlainText [

	| interface response |

	interface := RESTCommandsInterface workingWith: rootSystem.
	response := interface nextCommandAsPlainText.

	self assert: response equals: 'TURN_ON_LED'
]

{ #category : #tests }
RESTCommandsInterfaceTest >> testEnqueuingCommand [

	| interface prioritizedCommand |

	interface := RESTCommandsInterface workingWith: rootSystem.
	prioritizedCommand := interface push: '{
	"command" : "TURN_ON_LED",
	"priority" : "high"
}'.

	self assert: (self commandManagementSystem prioritizedCommands includes: prioritizedCommand)

	
]

{ #category : #tests }
RESTCommandsInterfaceTest >> testQueryingPrioitizedCommands [

	| interface response |

	interface := RESTCommandsInterface workingWith: rootSystem.
	response := interface prioritizedCommands.

	self assert: response equals: '[
	{
		"command" : "TURN_ON_LED",
		"priority" : "High"
	}
]'
]
