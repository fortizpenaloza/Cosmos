Class {
	#name : #CosmosAPIUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'api'
	],
	#category : #'Cosmos-API-Common-Tests'
}

{ #category : #'private - accessing' }
CosmosAPIUserStoryTest >> baseUrl [

	^ 'http://localhost' asUrl port: self port
]

{ #category : #running }
CosmosAPIUserStoryTest >> checkPortAvailability [

	[ | socket |

	socket := ZnNetworkingUtils serverSocketOn: self port.
	socket close
	]
		on: Error
		do: [ :error | self fail: ( 'Port <1p> is not available' expandMacrosWith: self port ) ]
]

{ #category : #'private - accessing' }
CosmosAPIUserStoryTest >> newClient [

	^ ZnClient new
		beOneShot;
		enforceHttpSuccess: true;
		yourself
]

{ #category : #'private - accessing' }
CosmosAPIUserStoryTest >> port [

	^ 9999
]

{ #category : #running }
CosmosAPIUserStoryTest >> setUp [

	super setUp.
	self checkPortAvailability.

	api := HTTPBasedRESTfulAPI
		configuredBy:
			{( #port -> self port ).
			( #serverUrl -> self baseUrl )}
		installing:
			{( DataStreamsRESTfulController workingWith: rootSystem ).
			( DataPointsRESTfulController workingWith: rootSystem ).
			( CommandsRESTfulController workingWith: rootSystem ).
			( ActionsRESTfulController workingWith: rootSystem ).
			( ActionEvaluationsRESTfulController workingWith: rootSystem ).
			( TriggersRESTfulController workingWith: rootSystem )}.

	api on: Error addErrorHandler: [ :error :request | self fail ].

	api
		install;
		start
]

{ #category : #running }
CosmosAPIUserStoryTest >> setUpRequirements [

	self
		registerSubsystem: (TimeSystem using: (FixedTimeSource on: self systemDateTime));
		registerSubsystem: EventNotificationSystem new;
		registerSubsystem: MetadataSystem new;
		registerSubsystem: (IdentifierSystem using: self identifierProvider);
		registerSubsystem: TimestampingSystem new;
		registerSubsystem: DataStreamManagementSystem new
]

{ #category : #'private - accessing' }
CosmosAPIUserStoryTest >> systemDateTime [

	^ DateTime 
		date: October first , 2014 
		timeOfDay: TimeOfDay noon 
		zone: TimeZones buenosAires
]

{ #category : #running }
CosmosAPIUserStoryTest >> tearDown [

	api ifNotNil: [ api stop ].
	api := nil.
	super tearDown
]

{ #category : #running }
CosmosAPIUserStoryTest >> testCORSHeadersWhenNoAllowedOriginMatches [

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
CosmosAPIUserStoryTest >> testCORSHeadersWhenOriginIsAllowed [

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
