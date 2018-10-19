Class {
	#name : #CommandsWebServiceTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'interface',
		'identifierSequence'
	],
	#category : #'Cosmos-API-Commands-Tests'
}

{ #category : #'accessing - media types' }
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

{ #category : #'accessing - requests' }
CommandsWebServiceTest >> requestToCreateCommandFrom: aJson [

	^ (ZnRequest post: 'http://COSMOS_URL/commands')
		entity: (ZnEntity json: aJson)
]

{ #category : #'accessing - requests' }
CommandsWebServiceTest >> requestToDeleteCommandIdentifiedBy: anIdentifier [

	^ TeaRequest
		fromZnRequest: (ZnRequest delete: 'http://COSMOS_URL/commands/' , anIdentifier asString)
		pathParams: {(#identifier -> anIdentifier)} asDictionary
]

{ #category : #'accessing - requests' }
CommandsWebServiceTest >> requestToGetCommands [

	^ (ZnRequest get: 'http://COSMOS_URL/commands')
		setAccept: self applicationJsonVersion1dot0dot0
]

{ #category : #'accessing - requests' }
CommandsWebServiceTest >> requestToNextCommandAccepting: mediaType [

	^ (ZnRequest post: 'http://COSMOS_URL/commands/next')
		setAccept: mediaType
]

{ #category : #running }
CommandsWebServiceTest >> setUp [

	identifierSequence := {UUID new.
	UUID new}.

	super setUp.

	interface := CommandsRESTfulWebService workingWith: rootSystem
]

{ #category : #running }
CommandsWebServiceTest >> setUpRequirements [

	super
		setUpRequirements;
		requireCommandManagementSystem.

]

{ #category : #tests }
CommandsWebServiceTest >> testCreateCommand [

	| response |

	self assert: self commandManagementSystem commands isEmpty.

	response := interface
		createCommandBasedOn: (self requestToCreateCommandFrom: '{"command":"TURN_ON_LED","priority":100}')
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 201;
		assert: response location equals: '/commands/' , identifierSequence first asString;
		assert: response contentType equals: ZnMimeType textPlain.

	self
		withTheOnlyOneIn: self commandManagementSystem commands
		do: [ :commandWithPriority | 
			self
				assert: commandWithPriority command equals: 'TURN_ON_LED';
				assert: commandWithPriority priority equals: 100 ]
]

{ #category : #tests }
CommandsWebServiceTest >> testDeleteCommand [

	| response |

	self installLedCommandsAddOn.

	self assert: self commandManagementSystem commands size equals: 3.

	response := interface
		deleteCommandBasedOn: (self requestToDeleteCommandIdentifiedBy: self commandWithMediumPriorityIdentifier)
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response status equals: 204;
		deny: response hasEntity;
		assert: self commandManagementSystem commands size equals: 2
]

{ #category : #tests }
CommandsWebServiceTest >> testGettingCommands [

	| response |

	self installLedCommandsAddOn.

	response := interface
		getCommandsBasedOn: self requestToGetCommands
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 200;
		assert: response contentType equals: self applicationJsonVersion1dot0dot0;
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
			(self
				requestToNextCommandAccepting: self applicationJsonVersion1dot0dot0)
		within: self httpRequestContext.

	self
		assert: response isSuccess;
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
		nextCommandBasedOn: (self requestToNextCommandAccepting: self textPlain)
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 200;
		assert: response contentType equals: ZnMimeType textPlain.

	self assert: response contents equals: 'TURN_ON_LED'
]

{ #category : #tests }
CommandsWebServiceTest >> testRoutesConfiguration [

	| teapot |

	teapot := Teapot on.

	(ReflectiveRoutesConfigurator appliedTo: teapot) addRoutesOf: interface.

	self assert: teapot routes size equals: 4
]

{ #category : #'accessing - media types' }
CommandsWebServiceTest >> textPlain [

	^ ZnMimeType textPlain
]
