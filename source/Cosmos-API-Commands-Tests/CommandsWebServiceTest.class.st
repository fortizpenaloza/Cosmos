Class {
	#name : #CommandsWebServiceTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'interface',
		'identifierSequence'
	],
	#category : #'Cosmos-API-Commands-Tests'
}

{ #category : #accessing }
CommandsWebServiceTest >> applicationJsonVersion1dot0dot0 [

	^ ZnMimeType applicationJson
		parameters: {('version' -> '1.0.0')} asDictionary;
		yourself
]

{ #category : #accessing }
CommandsWebServiceTest >> commandWithMediumPriorityIdentifier [

	^ identifierSequence second
]

{ #category : #accessing }
CommandsWebServiceTest >> httpRequestContext [

	^ HttpRequestContext new
]

{ #category : #accessing }
CommandsWebServiceTest >> identifierProvider [

	^ SequentialIdentifierProvider providing: identifierSequence 
]

{ #category : #'tests - support' }
CommandsWebServiceTest >> installLedCommandsAddOn [

	^ (LEDCommandsAddOn on: rootSystem) install
]

{ #category : #running }
CommandsWebServiceTest >> setUp [

	identifierSequence := {UUID new.
	UUID new}.

	super setUp.

	interface := CommandsWebService workingWith: rootSystem
]

{ #category : #running }
CommandsWebServiceTest >> setUpRequirements [

	super
		setUpRequirements;
		requireCommandManagementSystem.

]

{ #category : #tests }
CommandsWebServiceTest >> testCreatingCommand [

	| response |

	self assert: self commandManagementSystem commands isEmpty.

	response := interface
		createCommandBasedOn:
			((ZnRequest post: 'http://COSMOS_URL/commands')
				entity:
					(ZnEntity json: '{"command":"TURN_ON_LED","priority":100}'))
		within: self httpRequestContext.

	self
		assert: response code equals: 201;
		assert: response location
			equals: '/localhost/' , identifierSequence first asString36;
		assert: response contentType equals: ZnMimeType textPlain.

	self
		withTheOnlyOneIn: self commandManagementSystem commands
		do: [ :commandWithPriority | 
			self
				assert: commandWithPriority command equals: 'TURN_ON_LED';
				assert: commandWithPriority priority equals: 100 ]
]

{ #category : #tests }
CommandsWebServiceTest >> testDeletingCommand [

	| response |

	self installLedCommandsAddOn.

	self assert: self commandManagementSystem commands size equals: 3.

	response := interface
		deleteCommandBasedOn:
			(TeaRequest
				fromZnRequest:
					(ZnRequest
						delete:
							'http://COSMOS_URL/commands/'
								, self commandWithMediumPriorityIdentifier asString36)
				pathParams:
					{(#identifier -> self commandWithMediumPriorityIdentifier)}
						asDictionary)
		within: self httpRequestContext.


	self
		assert: response code equals: 204;
		assert: self commandManagementSystem commands size equals: 2
]

{ #category : #tests }
CommandsWebServiceTest >> testGettingCommands [

	| response |

	self installLedCommandsAddOn.

	response := interface
		getCommandsBasedOn:
			((ZnRequest get: 'http://COSMOS_URL/commands')
				setAccept: self applicationJsonVersion1dot0dot0)
		within: self httpRequestContext.

	self
		assert: response code equals: 200;
		assert: response contents
			equals:
			'[{"command":"TURN_ON_LED","priority":100},{"command":"TURN_OFF_LED","priority":50},{"command":"TURN_ON_LED","priority":1}]'
]

{ #category : #tests }
CommandsWebServiceTest >> testNextCommandFormattedAsJson [

	| response |

	self installLedCommandsAddOn.

	response := interface
		nextCommandBasedOn:
			((ZnRequest post: 'http://COSMOS_URL/commands/next')
				setAccept: self applicationJsonVersion1dot0dot0)
		within: self httpRequestContext.

	self
		assert: response code equals: 200;
		assert: response contentType
			equals: self applicationJsonVersion1dot0dot0.

	self
		assert: response contents
		equals: '{"command":"TURN_ON_LED","priority":100}'
]

{ #category : #tests }
CommandsWebServiceTest >> testNextCommandFormattedAsPlainText [

	| response |

	self installLedCommandsAddOn.

	response := interface
		nextCommandBasedOn:
			((ZnRequest post: 'http://COSMOS_URL/commands/next')
				setAccept: ZnMimeType textPlain)
		within: self httpRequestContext.

	self
		assert: response code equals: 200;
		assert: response contentType equals: ZnMimeType textPlain.

	self assert: response contents equals: 'TURN_ON_LED'
]
