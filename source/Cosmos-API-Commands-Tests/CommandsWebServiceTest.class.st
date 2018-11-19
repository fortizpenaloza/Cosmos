Class {
	#name : #CommandsWebServiceTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'identifierSequence',
		'controller'
	],
	#category : #'Cosmos-API-Commands-Tests'
}

{ #category : #'accessing - media types' }
CommandsWebServiceTest >> applicationJsonVersion1dot0dot0MediaType [

	^ 'application/json;version=1.0.0' asMediaType
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
CommandsWebServiceTest >> requestToDequeueCommandAccepting: aMediaType [

	^ (ZnRequest post: 'http://COSMOS_URL/commands/dequeue')
		setAccept: aMediaType
]

{ #category : #'accessing - requests' }
CommandsWebServiceTest >> requestToGetCommands [

	^ (ZnRequest get: 'http://COSMOS_URL/commands')
		setAccept: self applicationJsonVersion1dot0dot0MediaType
]

{ #category : #running }
CommandsWebServiceTest >> setUp [

	identifierSequence := {UUID new.
	UUID new}.

	super setUp.

	controller := CommandsRESTfulController workingWith: rootSystem
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

	response := controller
		createCommandBasedOn: (self requestToCreateCommandFrom: '{"command":"TURN_ON_LED","priority":100}')
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 201;
		assert: response location equals: '/commands/' , identifierSequence first asString;
		assert: response contentType equals: self textPlain.

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

	response := controller
		deleteCommandBasedOn: (self requestToDeleteCommandIdentifiedBy: self commandWithMediumPriorityIdentifier)
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response status equals: 204;
		deny: response hasEntity;
		assert: self commandManagementSystem commands size equals: 2
]

{ #category : #tests }
CommandsWebServiceTest >> testDequeueCommandEncodedAsJson [

	| response |

	self installLedCommandsAddOn.

	response := controller
		dequeueCommandBasedOn:
			(self
				requestToDequeueCommandAccepting: self applicationJsonVersion1dot0dot0MediaType)
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 200;
		assert: response contentType
			equals: self applicationJsonVersion1dot0dot0MediaType.

	self
		assert: response contents
		equals: '{"command":"TURN_ON_LED","priority":100}'
]

{ #category : #tests }
CommandsWebServiceTest >> testDequeueCommandEncodedAsPlainText [

	| response |

	self installLedCommandsAddOn.

	response := controller
		dequeueCommandBasedOn: (self requestToDequeueCommandAccepting: self textPlain)
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 200;
		assert: response contentType equals: ZnMimeType textPlain.

	self assert: response contents equals: 'TURN_ON_LED'
]

{ #category : #tests }
CommandsWebServiceTest >> testGettingCommands [

	| response |

	self installLedCommandsAddOn.

	response := controller
		getCommandsBasedOn: self requestToGetCommands
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 200;
		assert: response contentType equals: self applicationJsonVersion1dot0dot0MediaType;
		assert: response contents
			equals:
			'[{"command":"TURN_ON_LED","priority":100},{"command":"TURN_OFF_LED","priority":50},{"command":"TURN_ON_LED","priority":1}]'
]

{ #category : #'accessing - media types' }
CommandsWebServiceTest >> textPlain [

	^ 'text/plain;charset=utf-8' asZnMimeType
]
