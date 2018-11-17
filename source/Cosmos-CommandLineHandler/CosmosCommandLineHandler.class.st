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

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> allowedOrigins [

	^ self configuration at: 'allowed-origins'
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> baseUrl [

	^ ('http://' , self hostname) asUrl port: self port
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

	| api |

	api := HTTPBasedRESTfulAPI
		configuredBy:
			{(#port -> self port).
			(#debugMode -> self isDebugModeEnabled).
			(#serverUrl -> self baseUrl)}
		installing:
			{(DataStreamsRESTfulController workingWith: cosmos).
			(DataPointsRESTfulController workingWith: cosmos).
			(CommandsRESTfulController workingWith: cosmos).
			(ActionsRESTfulController workingWith: cosmos).
			(TriggersRESTfulController workingWith: cosmos)}.

	api install.
	api beCORSAwareAllowing: self allowedOrigins.
	api start
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
				named: 'hostname'
				defaultingTo: 'localhost');
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

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> hostname [

	^ self configuration at: 'hostname'
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
CosmosCommandLineHandler >> port [

	^ self configuration at: 'port'
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> timePeriodsToSchedule [

	^ {(TimeUnits second with: 10).
	(TimeUnits minute with: 1).
	(TimeUnits minute with: 10).
	(TimeUnits hour with: 1)}
]
