Class {
	#name : #CommandsRESTfulControllerTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'identifierSequence',
		'resourceController'
	],
	#category : #'Cosmos-API-Commands-Tests'
}

{ #category : #'private - media types' }
CommandsRESTfulControllerTest >> applicationJsonVersion1dot0dot0MediaType [

	^ 'application/json;version=1.0.0' asMediaType
]

{ #category : #'private - accessing' }
CommandsRESTfulControllerTest >> baseUrl [

	^ 'https://tests.cosmos.com' asZnUrl
]

{ #category : #'private - accessing' }
CommandsRESTfulControllerTest >> commandWithMediumPriorityIdentifier [

	^ identifierSequence second
]

{ #category : #'private - accessing' }
CommandsRESTfulControllerTest >> httpRequestContext [

	^ HttpRequestContext new
]

{ #category : #'private - accessing' }
CommandsRESTfulControllerTest >> identifierProvider [

	^ SequentialIdentifierProvider providing: identifierSequence 
]

{ #category : #'tests - support' }
CommandsRESTfulControllerTest >> installLedCommandsAddOn [

	^ (LEDCommandsAddOn on: rootSystem) install
]

{ #category : #'private - requests' }
CommandsRESTfulControllerTest >> requestToCreateCommandFrom: aJson [

	^ (ZnRequest post: 'http://COSMOS_URL/commands')
		entity: (ZnEntity json: aJson)
]

{ #category : #'private - requests' }
CommandsRESTfulControllerTest >> requestToDeleteCommandIdentifiedBy: anIdentifier [

	^ TeaRequest
		fromZnRequest: (ZnRequest delete: (self urlForResourceIdentifiedBy: anIdentifier))
		pathParams: {(#identifier -> anIdentifier)} asDictionary
]

{ #category : #'private - requests' }
CommandsRESTfulControllerTest >> requestToDequeueCommandAccepting: aMediaType [

	^ (ZnRequest post: 'http://COSMOS_URL/commands/dequeue')
		setAccept: aMediaType
]

{ #category : #'private - requests' }
CommandsRESTfulControllerTest >> requestToGet: aUrl accepting: aMediaType [

	^ TeaRequest
		fromZnRequest:
			((ZnRequest get: aUrl)
				setAccept: aMediaType;
				yourself)
]

{ #category : #'private - requests' }
CommandsRESTfulControllerTest >> requestToGetCommandIdentifiedBy: anIdentifier accepting: aMediaType [

	self halt.
	^ TeaRequest
		fromZnRequest:
			((ZnRequest get: (self urlForResourceIdentifiedBy: anIdentifier))
				setAccept: aMediaType;
				yourself)
		pathParams: {(#identifier -> anIdentifier)} asDictionary
]

{ #category : #'private - requests' }
CommandsRESTfulControllerTest >> requestToGetCommandsAccepting: aMediaType [

	^ self requestToGet: self resourceUrl accepting: aMediaType
]

{ #category : #'private - accessing' }
CommandsRESTfulControllerTest >> resourceUrl [

	^ self baseUrl / resourceController specification endpoint
]

{ #category : #running }
CommandsRESTfulControllerTest >> setUp [

	identifierSequence := {
	(UUID fromString: 'af1ac24c-6c37-0d00-8b39-e65c01b794dc').
	(UUID fromString: '7606aa4d-6c37-0d00-8b3a-dd4a01b794dc').
	(UUID fromString: 'a3ad3f02-7137-0d00-ad4c-8ce2051f8f4c')}.

	super setUp.

	resourceController := CommandsRESTfulController workingWith: rootSystem.
	resourceController serverUrl: self baseUrl asZnUrl
]

{ #category : #running }
CommandsRESTfulControllerTest >> setUpRequirements [

	super
		setUpRequirements;
		requireCommandManagementSystem
]

{ #category : #tests }
CommandsRESTfulControllerTest >> testCreateCommand [

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
CommandsRESTfulControllerTest >> testDeleteCommand [

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
CommandsRESTfulControllerTest >> testDequeueCommandEncodedAsJson [

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
CommandsRESTfulControllerTest >> testDequeueCommandEncodedAsPlainText [

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
CommandsRESTfulControllerTest >> testGetCommand [

	| response |

	self installLedCommandsAddOn.

	response := resourceController
		getCommandBasedOn:
			(self
				requestToGetCommandIdentifiedBy: self turnOnLedWithHighestPriorityIndentifier
				accepting: self applicationJsonVersion1dot0dot0MediaType)
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 200;
		assert: response contentType equals: self applicationJsonVersion1dot0dot0MediaType;
		assert: response entityTag equals: '"a1530d41d5b133615991dfb44210dd5ce144aa8a"' asETag;
		withJsonFromContentsIn: response contents
			do: [ :json | 
			self
				assert: json priority equals: 100;
				assert: json command equals: 'TURN_ON_LED';
				assert: json links self
					equals: 'https://tests.cosmos.com/commands/af1ac24c-6c37-0d00-8b39-e65c01b794dc' ]
]

{ #category : #tests }
CommandsRESTfulControllerTest >> testGetCommands [

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
			'[{"command":"TURN_ON_LED","priority":100,"links":{"self":"https://tests.cosmos.com/commands/af1ac24c-6c37-0d00-8b39-e65c01b794dc"}},{"command":"TURN_OFF_LED","priority":50,"links":{"self":"https://tests.cosmos.com/commands/7606aa4d-6c37-0d00-8b3a-dd4a01b794dc"}},{"command":"TURN_ON_LED","priority":1,"links":{"self":"https://tests.cosmos.com/commands/a3ad3f02-7137-0d00-ad4c-8ce2051f8f4c"}}]'
]

{ #category : #'private - media types' }
CommandsRESTfulControllerTest >> textPlain [

	^ 'text/plain;charset=utf-8' asZnMimeType
]

{ #category : #accessing }
CommandsRESTfulControllerTest >> turnOnLedWithHighestPriorityIndentifier [
	
	^ identifierSequence first
]

{ #category : #'private - accessing' }
CommandsRESTfulControllerTest >> urlForResourceIdentifiedBy: anIdentifier [

	^ self resourceUrl / anIdentifier printString asZnUrl
]
