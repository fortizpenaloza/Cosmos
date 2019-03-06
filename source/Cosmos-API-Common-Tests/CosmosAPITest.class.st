Class {
	#name : #CosmosAPITest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'api'
	],
	#category : #'Cosmos-API-Common-Tests'
}

{ #category : #'private - accessing' }
CosmosAPITest >> baseUrl [

	^ 'http://localhost' asUrl port: self port
]

{ #category : #'private - accessing' }
CosmosAPITest >> newClient [

	^ ZnClient new
		beOneShot;
		yourself
]

{ #category : #'private - accessing' }
CosmosAPITest >> port [

	^ 9999
]

{ #category : #running }
CosmosAPITest >> setUp [

	super setUp.
	api := HTTPBasedRESTfulAPI
		configuredBy:
			{(#port -> self port).
			(#debugMode -> true).
			(#serverUrl -> self baseUrl)}
		installing:
			{(DataStreamsRESTfulController workingWith: rootSystem).
			(DataPointsRESTfulController workingWith: rootSystem).
			(CommandsRESTfulController workingWith: rootSystem).
			(ActionsRESTfulController workingWith: rootSystem).
			(ActionEvaluationSummariesRESTfulController workingWith: rootSystem).
			(TriggersRESTfulController workingWith: rootSystem)}.

	api
		install;
		start
]

{ #category : #running }
CosmosAPITest >> setUpRequirements [

	self
		registerSubsystem: (TimeSystem using: (FixedTimeSource on: self systemDateTime));
		registerSubsystem: EventNotificationSystem new;
		registerSubsystem: MetadataSystem new;
		registerSubsystem: (IdentifierSystem using: self identifierProvider);
		registerSubsystem: TimestampingSystem new;
		registerSubsystem: DataStreamManagementSystem new;
		registerSubsystem: ActionManagementSystem new;
		registerSubsystem: TriggerManagementSystem new
]

{ #category : #'private - accessing' }
CosmosAPITest >> systemDateTime [

	^ DateTime 
		date: October first , 2014 
		timeOfDay: TimeOfDay noon 
		zone: TimeZones buenosAires
]

{ #category : #running }
CosmosAPITest >> tearDown [

	api ifNotNil: [ api stop ].
	api := nil.
	super tearDown
]

{ #category : #running }
CosmosAPITest >> testCORSHeadersWhenNoAllowedOriginMatches [

	| response |

	api beCORSAwareAllowing: {'http://localhost' asUrl port: 8211}.
	response := self newClient
		url: self baseUrl / 'data-streams' asUrl;
		headerAt: 'Access-Control-Request-Method' put: 'POST';
		headerAt: 'Access-Control-Request-Headers' put: 'Origin';
		headerAt: 'Origin' put: self baseUrl printString;
		options;
		response.

	self
		deny: (response headers includesKey: 'Vary');
		deny: (response headers includesKey: 'Access-Control-Allow-Origin');
		assert: (response headers at: 'Access-Control-Allow-Headers') equals: 'Access-Control-Allow-Origin, Content-Type, Accept';
		assert: (response headers at: 'Access-Control-Allow-Methods') equals: 'POST'
]

{ #category : #running }
CosmosAPITest >> testCORSHeadersWhenOriginIsAllowed [

	| response |

	api beCORSAwareAllowing: {self baseUrl}.
	response := self newClient
		url: self baseUrl / 'data-streams' asUrl;
		headerAt: 'Access-Control-Request-Method' put: 'POST';
		headerAt: 'Access-Control-Request-Headers' put: 'Origin';
		headerAt: 'Origin' put: self baseUrl printString;
		options;
		response.

	self
		assert: (response headers at: 'Vary') equals: 'Origin';
		assert: (response headers at: 'Access-Control-Allow-Origin') asUrl equals: self baseUrl;
		assert: (response headers at: 'Access-Control-Allow-Headers') equals: 'Access-Control-Allow-Origin, Content-Type, Accept';
		assert: (response headers at: 'Access-Control-Allow-Methods') equals: 'POST'
]
