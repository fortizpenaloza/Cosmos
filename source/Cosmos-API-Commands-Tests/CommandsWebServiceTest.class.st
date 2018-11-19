Class {
	#name : #CommandsWebServiceTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'identifierSequence',
		'resourceController'
	],
	#category : #'Cosmos-API-Commands-Tests'
}

{ #category : #'private - media types' }
CommandsWebServiceTest >> applicationJsonVersion1dot0dot0MediaType [

	^ 'application/json;version=1.0.0' asMediaType
]

{ #category : #'private - accessing' }
CommandsWebServiceTest >> baseUrl [

	^ 'https://tests.cosmos.com' asZnUrl
]

{ #category : #'private - accessing' }
CommandsWebServiceTest >> commandWithMediumPriorityIdentifier [

	^ identifierSequence second
]

{ #category : #'private - accessing' }
CommandsWebServiceTest >> httpRequestContext [

	^ HttpRequestContext new
]

{ #category : #'private - accessing' }
CommandsWebServiceTest >> identifierProvider [

	^ SequentialIdentifierProvider providing: identifierSequence 
]

{ #category : #'tests - support' }
CommandsWebServiceTest >> installLedCommandsAddOn [

	^ (LEDCommandsAddOn on: rootSystem) install
]

{ #category : #'private - requests' }
CommandsWebServiceTest >> requestToCreateCommandFrom: aJson [

	^ (ZnRequest post: 'http://COSMOS_URL/commands')
		entity: (ZnEntity json: aJson)
]

{ #category : #'private - requests' }
CommandsWebServiceTest >> requestToDeleteCommandIdentifiedBy: anIdentifier [

	^ TeaRequest
		fromZnRequest: (ZnRequest delete: (self urlForResourceIdentifiedBy: anIdentifier))
		pathParams: {(#identifier -> anIdentifier)} asDictionary
]

{ #category : #'private - requests' }
CommandsWebServiceTest >> requestToDequeueCommandAccepting: aMediaType [

	^ (ZnRequest post: 'http://COSMOS_URL/commands/dequeue')
		setAccept: aMediaType
]

{ #category : #'as yet unclassified' }
CommandsWebServiceTest >> requestToGet: aUrl accepting: aMediaType [

	^ TeaRequest
		fromZnRequest:
			((ZnRequest get: aUrl)
				setAccept: aMediaType;
				yourself)
]

{ #category : #'private - requests' }
CommandsWebServiceTest >> requestToGetCommandsAccepting: aMediaType [

	^ self requestToGet: self resourceUrl accepting: aMediaType
]

{ #category : #'private - accessing' }
CommandsWebServiceTest >> resourceUrl [

	^ self baseUrl / resourceController specification endpoint
]

{ #category : #running }
CommandsWebServiceTest >> setUp [

	identifierSequence := {
	(UUID fromString: 'af1ac24c-6c37-0d00-8b39-e65c01b794dc').
	(UUID fromString: '7606aa4d-6c37-0d00-8b3a-dd4a01b794dc')}.

	super setUp.

	resourceController := CommandsRESTfulController workingWith: rootSystem.
	resourceController serverUrl: self baseUrl asZnUrl
]

{ #category : #running }
CommandsWebServiceTest >> setUpRequirements [

	super
		setUpRequirements;
		requireCommandManagementSystem
]

{ #category : #tests }
CommandsWebServiceTest >> testCreateCommand [

	| response |

	self assert: self commandManagementSystem commands isEmpty.

	response := resourceController
		createCommandBasedOn: (self requestToCreateCommandFrom: '{"command":"TURN_ON_LED","priority":100}')
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 201;
		assert: response location
			equals: 'https://tests.cosmos.com/commands/af1ac24c-6c37-0d00-8b39-e65c01b794dc';
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

	response := resourceController
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

	response := resourceController
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
		equals: '{"command":"TURN_ON_LED","priority":100,"links":{"self":"https://tests.cosmos.com/commands/af1ac24c-6c37-0d00-8b39-e65c01b794dc"}}'
]

{ #category : #tests }
CommandsWebServiceTest >> testDequeueCommandEncodedAsPlainText [

	| response |

	self installLedCommandsAddOn.

	response := resourceController
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

	response := resourceController
		getCommandsBasedOn: (self requestToGetCommandsAccepting: self applicationJsonVersion1dot0dot0MediaType)
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 200;
		assert: response contentType equals: self applicationJsonVersion1dot0dot0MediaType;
		assert: response contents
			equals:
			'[{"command":"TURN_ON_LED","priority":100,"links":{"self":"https://tests.cosmos.com/commands/af1ac24c-6c37-0d00-8b39-e65c01b794dc"}},{"command":"TURN_OFF_LED","priority":50,"links":{"self":"https://tests.cosmos.com/commands/7606aa4d-6c37-0d00-8b3a-dd4a01b794dc"}},{"command":"TURN_ON_LED","priority":1,"links":{"self":"https://tests.cosmos.com/commands/af1ac24c-6c37-0d00-8b39-e65c01b794dc"}}]'
]

{ #category : #'private - media types' }
CommandsWebServiceTest >> textPlain [

	^ 'text/plain;charset=utf-8' asZnMimeType
]

{ #category : #'private - accessing' }
CommandsWebServiceTest >> urlForResourceIdentifiedBy: anIdentifier [

	^ self resourceUrl / anIdentifier printString asZnUrl
]
