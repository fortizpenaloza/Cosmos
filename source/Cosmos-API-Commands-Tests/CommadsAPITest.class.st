Class {
	#name : #CommadsAPITest,
	#superclass : #RESTfulAPIUserStoryTest,
	#instVars : [
		'commandsController'
	],
	#category : #'Cosmos-API-Commands-Tests'
}

{ #category : #running }
CommadsAPITest >> controllersToInstall [

	commandsController := CommandsRESTfulController workingWith: rootSystem.
	
	^ {commandsController}
]

{ #category : #'private - running' }
CommadsAPITest >> setUpRequirements [

	self flag: 'requireCommandManagementSystem'.

	self
		registerSubsystem: (TimeSystem using: (FixedTimeSource on: self systemDateTime));
		registerSubsystem: MetadataSystem new;
		registerSubsystem: (IdentifierSystem using: self identifierProvider);
		registerSubsystem: TimestampingSystem new;
		registerSubsystem: CommandManagementSystem new
]

{ #category : #tests }
CommadsAPITest >> testCreateCommand [

	self
		withCreatedCommandResponseDo: [ :response | 
			self
				assert: response isSuccess;
				assert: response code equals: 201;
				assert: response location notEmpty;
				assert: response contentType equals: commandsController commandVersion1dot0dot0MediaType;
				assert: response hasEntity
			]
]

{ #category : #tests }
CommadsAPITest >> testDeleteCommand [

	self
		withCreatedCommandLocationDo: [ :location | 
			| response |

			response := self newClient
				url: location;
				delete;
				response.

			self
				assert: response isSuccess;
				assert: response code equals: 204;
				deny: response hasEntity
			]
]

{ #category : #tests }
CommadsAPITest >> testGetCommand [

	self
		withCreatedCommandLocationDo: [ :location | 
			| response |

			response := self newClient
				url: location;
				get;
				response.

			self
				assert: response isSuccess;
				assert: response code equals: 200;
				assert: response hasEntity
			]
]

{ #category : #tests }
CommadsAPITest >> testGetCommands [

	| response |

	response := self newClient
		url: self baseUrl / commandsController endpoint;
		get;
		response.

	self
		assert: response isSuccess;
		assert: response code equals: 200;
		assert: response hasEntity
]

{ #category : #tests }
CommadsAPITest >> testGetPrioritizedCommands [

	| url response |
	
	url := (self baseUrl / commandsController endpoint) queryAt: 'order' put: 'priority'.

	response := self newClient
		url: url;
		get;
		response.

	self
		assert: response isSuccess;
		assert: response code equals: 200;
		assert: response hasEntity
]

{ #category : #'tests - support' }
CommadsAPITest >> withCreatedCommandLocationDo: aBlock [

	self withCreatedCommandResponseDo: [ :response | aBlock value: response location ]
]

{ #category : #'tests - support' }
CommadsAPITest >> withCreatedCommandResponseDo: aBlock [

	| response |

	response := self newClient
		url: self baseUrl / commandsController endpoint;
		entity:
			( ZnEntity
				with: '{"command":"TURN_ON_LED","priority":100}'
				ofType: commandsController commandVersion1dot0dot0MediaType );
		post;
		response.
		
	aBlock value: response
]
