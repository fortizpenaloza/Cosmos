Class {
	#name : #CommandsAPITest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'interface',
		'identifierSequence'
	],
	#category : #'Cosmos-API-Commands-Tests'
}

{ #category : #history }
CommandsAPITest class >> lastStoredRun [
	^ ((Dictionary new) add: (#timeStamp->(DateAndTime basicNew instVarAt: 1 put: 6510; instVarAt: 2 put: (Duration seconds: -10800 nanoSeconds: 0); instVarAt: 3 put: 2458339; instVarAt: 4 put: 645979000; yourself)); add: (#passed->((Set new) add: #testNextCommandFormattedAsJson; add: #testCreatingCommand; add: #testGettingCommands; add: #testNextCommandFormattedAsPlainText; yourself)); add: (#failures->((Set new))); add: (#errors->((Set new))); yourself)
]

{ #category : #accessing }
CommandsAPITest >> applicationJsonVersion1dot0dot0 [

	^ ZnMimeType applicationJson
		parameters: {('version' -> '1.0.0')} asDictionary;
		yourself
]

{ #category : #accessing }
CommandsAPITest >> identifierProvider [

	^ SequentialIdentifierProvider providing: identifierSequence 
]

{ #category : #'tests - support' }
CommandsAPITest >> installLedCommandsAddOn [

	^ (LEDCommandsAddOn on: rootSystem) install
]

{ #category : #running }
CommandsAPITest >> setUp [

	identifierSequence := {UUID new.
	UUID new}.

	super setUp.

	interface := (CommandsAPIInstaller toInstallOn: Teapot on workingWith: rootSystem) install
]

{ #category : #running }
CommandsAPITest >> setUpRequirements [

	super
		setUpRequirements;
		requireCommandManagementSystem.

]

{ #category : #tests }
CommandsAPITest >> testCreatingCommand [

	| response |

	self assert: self commandManagementSystem commands isEmpty.

	response := interface
		createCommandBasedOn:
			((ZnRequest post: 'http://COSMOS_URL/commands')
				entity:
					(ZnEntity
						json:
							'{
	"command" : "TURN_ON_LED",
	"priority" : 100
}')).

	self
		assert: response code equals: 201;
		assert: response location equals: '/localhost/' , identifierSequence first asString36;
		assert: response contentType equals: ZnMimeType textPlain.

	self
		withTheOnlyOneIn: self commandManagementSystem commands
		do: [ :commandWithPriority | 
			self
				assert: commandWithPriority command equals: 'TURN_ON_LED';
				assert: commandWithPriority priority equals: 100 ]
]

{ #category : #tests }
CommandsAPITest >> testGettingCommands [

	| response |

	self installLedCommandsAddOn.
	
	response := interface
		getCommandsBasedOn:
			((ZnRequest get: 'http://COSMOS_URL/commands')
				setAccept: self applicationJsonVersion1dot0dot0).

	self
		assert: response code equals: 200;
		assert: response contents
			equals:
			'[{"command":"TURN_ON_LED","priority":100},{"command":"TURN_OFF_LED","priority":50},{"command":"TURN_ON_LED","priority":1}]'
]

{ #category : #tests }
CommandsAPITest >> testNextCommandFormattedAsJson [

	| response |

	self installLedCommandsAddOn.

	response := interface
		nextCommandBasedOn:
			((ZnRequest post: 'http://COSMOS_URL/commands/next') setAccept: self applicationJsonVersion1dot0dot0).

	self
		assert: response code equals: 200;
		assert: response contentType equals: self applicationJsonVersion1dot0dot0.

	self assert: response contents equals: '{"command":"TURN_ON_LED","priority":100}'
]

{ #category : #tests }
CommandsAPITest >> testNextCommandFormattedAsPlainText [

	| response |

	self installLedCommandsAddOn.

	response := interface
		nextCommandBasedOn:
			((ZnRequest post: 'http://COSMOS_URL/commands/next') setAccept: ZnMimeType textPlain).

	self
		assert: response code equals: 200;
		assert: response contentType equals: ZnMimeType textPlain.

	self assert: response contents equals: 'TURN_ON_LED'
]
