"
Usage: printVersion [ --port | --debug-mode ]
	--port Port number for http server
	--debug-mode Http server should be installed in debug mode
	
Documentation:
Prints the version number in an easy to parse format. This can be used in Jenkins with the ""Description Setter"" Plugin. Configure it like this:

Regular expression:  \[version\] (.*)
Description: \1


Examples:
	pharo Pharo.image printVersion
	#result will be something like:
	[version] 3.0 #30100

	pharo Pharo.image printVersion --numeric
	# will print a simpler version
	30100
	
	pharo Pharo.image printVersion --release
	# prints the Pharo release version
	3.0
"
Class {
	#name : #CosmosCommandLineHandler,
	#superclass : #ApplicationStarterCommandLineHandler,
	#instVars : [
		'cosmos'
	],
	#category : #'Cosmos-CommandLineHandler'
}

{ #category : #accessing }
CosmosCommandLineHandler class >> commandName [

	^ 'cosmos'
]

{ #category : #accessing }
CosmosCommandLineHandler class >> description [

	^ 'Cosmos command line handler'
]

{ #category : #'private - activation' }
CosmosCommandLineHandler >> addAllowOriginHeaderTo: aResponse ifOriginAt: aRequest matchesAny: allowedOrigins [

	allowedOrigins
		detect: [ :origin | origin = (aRequest headers at: 'Origin') ]
		ifFound: [ :allowedOrigin | aResponse headers at: 'Access-Control-Allow-Origin' put: allowedOrigin ]
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> allowedOrigins [

	^ self configuration at: 'allowed-origins'
]

{ #category : #activation }
CosmosCommandLineHandler >> basicActivate [

	self
		logInfo: 'Building and starting cosmos' 
			during: [ self buildAndStartCosmos ];
		logInfo: 'Building and starting RESTful API' 
			during: [ self buildAndStartCosmosAPI ];
		logInfo: 'Building and starting the periodical scheduler'
			during: [ self buildAndStartScheduler ]
]

{ #category : #'private - activation' }
CosmosCommandLineHandler >> buildAndStartCosmos [

	| builder |

	builder := CompositeSystemBuilder new.
	builder
		add: (TimeSystem using: SystemTimeSource new);
		add: EventNotificationSystem new;
		add: MetadataSystem new;
		add: (IdentifierSystem using: UUIDProvider new);
		add: DataManagementSystem new;
		add: TriggerManagementSystem new;
		add: ActionManagementSystem new;
		add: CommandManagementSystem new.

	cosmos := builder build.

	cosmos startUp
]

{ #category : #'private - activation' }
CosmosCommandLineHandler >> buildAndStartCosmosAPI [

	| teapot configurator |

	teapot := self teapot.
	configurator := ReflectiveRoutesConfigurator appliedTo: teapot.

	configurator
		addRoutesOf: (DataStreamsRESTfulWebService workingWith: cosmos);
		addRoutesOf: (DataPointsRESTfulWebService workingWith: cosmos);
		addRoutesOf: (CommandsRESTfulWebService workingWith: cosmos);
		addRoutesOf: (ActionsWebService workingWith: cosmos).

	(TriggersRESTfulWebServiceSpecification toInstallOn: teapot workingWith: cosmos) install.

	self configureAllowOriginAfterFilterOn: teapot.
	self configureExceptionHandlerOn: teapot.

	teapot start
]

{ #category : #'private - activation' }
CosmosCommandLineHandler >> buildAndStartScheduler [

	| scheduler  |

	scheduler := self periodicalScheduler.
	
	self timePeriodsToSchedule
		do: [ :timePeriod | | task |

			task := Task
				named: ('Notify every <1p>' expandMacrosWith: timePeriod)
				do: [ (cosmos systemImplementing: #EventNotificationSystemInterface)
						notifySubscribersTo: (TickEvent of: timePeriod) ].

			scheduler schedule: task toBeExecutedEvery: timePeriod ].
		
	scheduler start
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> configurationDefinition [

	^ OrderedCollection new
		add:
			(OptionalArgument
				named: 'port'
				defaultingTo: 9000
				convertingWith: #asNumber);
		add:
			(MandatoryArgument
				named: 'allowed-origins'
				convertingWith: [ :string | string substrings: ',' ]);
		asArray
]

{ #category : #'private - activation' }
CosmosCommandLineHandler >> configureAllowOriginAfterFilterOn: aServer [

	aServer
		after:
			'/*'
				-> [ :request :response | 
					self
						addAllowOriginHeaderTo: response
						ifOriginAt: request
						matchesAny: self allowedOrigins.

					response ];
		when: [ :request | request headers includesKey: 'Origin' ]
]

{ #category : #'private - activation' }
CosmosCommandLineHandler >> configureExceptionHandlerOn: aServer [

	aServer
		exception:
			HTTPClientError
				-> [ :signal :request | 
					| errorMessage |

					errorMessage := Dictionary new
						at: #code put: signal tag;
						at: #message put: signal messageText;
						yourself.

					(ZnResponse statusCode: signal tag)
						headers:
							(ZnHeaders defaultResponseHeaders
								at: 'Access-Control-Allow-Origin' put: '*';
								yourself);
						entity: (ZnEntity json: (STONJSON toStringPretty: errorMessage));
						yourself ].

	aServer
		exception: self exceptionsToHandle -> [ :signal :request | self dumpStackAndReport: signal ]
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> logPrefix [

	^ 'cosmos'
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> periodicalScheduler [

	^ PeriodicalScheduler workingWith: DelaySpinScheduler new
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> portNumber [

	^ self configuration at: 'port'
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> teapot [

	^ Teapot
		configure:
			{(#port -> self portNumber).
			(#debugMode -> self isDebugModeEnabled)}
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> timePeriodsToSchedule [

	^ {(TimeUnits second with: 10).
	(TimeUnits minute with: 1).
	(TimeUnits minute with: 10).
	(TimeUnits hour with: 1)}
]
