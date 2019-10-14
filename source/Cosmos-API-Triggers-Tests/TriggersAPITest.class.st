Class {
	#name : #TriggersAPITest,
	#superclass : #RESTfulAPIUserStoryTest,
	#instVars : [
		'triggersController'
	],
	#category : #'Cosmos-API-Triggers-Tests'
}

{ #category : #running }
TriggersAPITest >> controllersToInstall [

	triggersController := TriggersRESTfulController workingWith: rootSystem.
	
	^ { triggersController }
]

{ #category : #running }
TriggersAPITest >> setUp [

	super setUp.

	( rootSystem systemImplementing: #ActionManagementSystemInterface )
		register: ( Action named: 'Set triggered to true' evaluating: [ "Do nothing" ] )
]

{ #category : #'private - running' }
TriggersAPITest >> setUpRequirements [

	self
		registerSubsystem: (TimeSystem using: (FixedTimeSource on: self systemDateTime));
		registerSubsystem: EventNotificationSystem new;
		registerSubsystem: MetadataSystem new;
		registerSubsystem: (IdentifierSystem using: self identifierProvider);
		registerSubsystem: TimestampingSystem new;
		registerSubsystem: ActionManagementSystem new;
		registerSubsystem: (TriggerManagementSystem enqueuingActionsInto: self)
]

{ #category : #tests }
TriggersAPITest >> testCreateTrigger [

	| response |

	response := self newClient
		url: self baseUrl / triggersController endpoint;
		entity:
			( ZnEntity
				with:
					'{"name":"Set triggered to true periodically every 5 minutes","action":"Set triggered to true","policy":{"type":"periodical","time_interval":"5 minutes"},"conditions":[]}'
				ofType: triggersController triggerVersion1dot0dot0MediaType );
		post;
		response.
		
	self
		assert: response isSuccess;
		assert: response code equals: 201
]

{ #category : #tests }
TriggersAPITest >> testDeleteTrigger [

	| response |

	self withCreatedTriggerLocationDo: [ :location | 
		
		response := self newClient 
			url: location;
			delete;
			response.
			
		self assert: response code equals: 204 ]
]

{ #category : #tests }
TriggersAPITest >> testGetTrigger [

	| response |

	self
		withCreatedTriggerLocationDo: [ :location | 
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
TriggersAPITest >> testGetTriggers [

	| response |

	response := self newClient
		url: self baseUrl / triggersController endpoint;
		get;
		response.

	self
		assert: response isSuccess;
		assert: response code equals: 200;
		assert: response hasEntity
]

{ #category : #'as yet unclassified' }
TriggersAPITest >> withCreatedTriggerLocationDo: aBlock [

	| response |

	response := self newClient
		url: self baseUrl / triggersController endpoint;
		entity: ( ZnEntity with: '{"name":"Set triggered to true periodically every 5 minutes","action":"Set triggered to true","policy":{"type":"periodical","time_interval":"5 minutes"},"conditions":[]}' ofType: triggersController triggerVersion1dot0dot0MediaType );
		post;
		response.

	aBlock value: response location
]
