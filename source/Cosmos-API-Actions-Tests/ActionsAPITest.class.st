Class {
	#name : #ActionsAPITest,
	#superclass : #RESTfulAPIUserStoryTest,
	#instVars : [
		'actionsController'
	],
	#category : #'Cosmos-API-Actions-Tests'
}

{ #category : #running }
ActionsAPITest >> controllersToInstall [

	actionsController := ActionsRESTfulController workingWith: rootSystem .
	
	^ { actionsController } 
]

{ #category : #'private - running' }
ActionsAPITest >> setUpRequirements [

	self
		registerSubsystem: (TimeSystem using: (FixedTimeSource on: self systemDateTime));
		registerSubsystem: EventNotificationSystem new;
		registerSubsystem: MetadataSystem new;
		registerSubsystem: TimestampingSystem new;
		registerSubsystem: (IdentifierSystem using: self identifierProvider);
		registerSubsystem: ActionManagementSystem new
]

{ #category : #tests }
ActionsAPITest >> testCreateAction [

	| response |

	response := self newClient
		url: self baseUrl / actionsController endpoint;
		entity:
			( ZnEntity
				with:
					'{"name":"OpenSprinkler","http_request":{"request_line":{"url":"http://localhost:8090/commands","method":"POST","version":"HTTP/1.1"},"headers":[{"key":"content-type","value":"application/json"}],"body":"{\"command\":\"Open Sprinkler\",\"priority\":30}"}}'
				ofType: actionsController actionVersion1dot0dot0MediaType );
		post;
		response.

	self
		assert: response isSuccess;
		assert: response code equals: 201;
		assert: response location notEmpty;
		assert: response contentType equals: actionsController actionVersion1dot0dot0MediaType;
		assert: response hasEntity
]

{ #category : #tests }
ActionsAPITest >> testDeleteAction [

	self
		withCreatedActionLocationDo: [ :location | 
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
ActionsAPITest >> testGetAction [

	| response |
	
	self
		withCreatedActionLocationDo: [ :location | 
			response := self newClient
				url: location;
				get;
				response.

			self
				assert: response isSuccess;
				assert: response code equals: 200;
				assert: response hasEntity ]
]

{ #category : #tests }
ActionsAPITest >> testGetActions [

	| response |

	response := self newClient
		url: self baseUrl / actionsController endpoint;
		get;
		response.

	self
		assert: response isSuccess;
		assert: response code equals: 200;
		assert: response hasEntity
]

{ #category : #'tests - support' }
ActionsAPITest >> withCreatedActionLocationDo: aBlock [

	|response |
	
	response := self newClient
		url: self baseUrl / actionsController endpoint;
		entity: ( ZnEntity with: '{"name":"OpenSprinkler","http_request":{"request_line":{"url":"http://localhost:8090/commands","method":"POST","version":"HTTP/1.1"},"headers":[{"key":"content-type","value":"application/json"}],"body":"{\"command\":\"Open Sprinkler\",\"priority\":30}"}}' ofType: actionsController actionVersion1dot0dot0MediaType );
		post;
		response.
		
	aBlock value: response location
]
