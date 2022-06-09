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
	#name : #CosmosApplication,
	#superclass : #LaunchpadApplication,
	#instVars : [
		'cosmos',
		'api',
		'pendingActionsQueue',
		'actionEvaluationsQueue',
		'actionEvaluator',
		'periodicalScheduler'
	],
	#category : #'Cosmos-CommandLineHandler'
}

{ #category : #accessing }
CosmosApplication class >> commandName [

	^ 'cosmos'
]

{ #category : #accessing }
CosmosApplication class >> configurationParameters [

	^ OrderedCollection new
		  add: ( OptionalConfigurationParameter
				    named: 'Public URL'
				    describedBy: 'Public URL where the API is deployed. Used to create hypermedia links'
				    defaultingTo: 'https://localhost' asUrl
				    convertingWith: #asUrl );
		  add: ( OptionalConfigurationParameter
				    named: 'Port'
				    describedBy: 'Listening port'
				    defaultingTo: 57001
				    convertingWith: #asNumber );
		  add: ( MandatoryConfigurationParameter
				    named: 'Allowed origins'
				    describedBy: 'List of allowed origins'
				    convertingWith: [ :string | ( ( string substrings: ',' ) collect: #trim ) collect: #asUrl ] );
		  asArray
]

{ #category : #accessing }
CosmosApplication class >> description [

	^ 'A Cosmos application'
]

{ #category : #'error handling' }
CosmosApplication class >> fileReferenceToDumpStackTrace [

	^ self logsDirectory / ( '<1s>-<2s>.fuel'
		    expandMacrosWith: self commandName
		    with:
			    ( ( ISO8601DateTimeFormatter usingExtendedFormat format: GregorianCalendar currentDateTime ) replaceAll: $: with: $_ ) )
]

{ #category : #'error handling' }
CosmosApplication class >> logsDirectory [

	^ FileLocator workingDirectory / 'logs'
]

{ #category : #accessing }
CosmosApplication class >> version [

	^ '1.0.0'
]

{ #category : #'private - accessing' }
CosmosApplication >> allowedOrigins [

	^ self configuration allowedOrigins
]

{ #category : #'private - accessing' }
CosmosApplication >> apiConfiguration [

	^ Array
		  with: #serverUrl -> self configuration publicURL
		  with: #port -> self configuration port
		  with: #debugMode -> self isDebugModeEnabled
]

{ #category : #'private - activation/deactivation' }
CosmosApplication >> basicStartWithin: context [

	self
		logAsInfo: 'Creating pending evaluation actions queue'
		during: [ pendingActionsQueue := AtomicSharedQueue new ];
		logAsInfo: 'Creating action evaluation queue'
		during: [ actionEvaluationsQueue := AtomicSharedQueue new ];
		logAsInfo: 'Building and starting cosmos' 
		during: [ self buildAndStartCosmos ];
		logAsInfo: 'Building and starting RESTful API' 
		during: [ self buildAndStartRESTfulAPI ];
		logAsInfo: 'Building and starting the periodical scheduler'
		during: [ self buildAndStartScheduler ];
		logAsInfo: 'Building and starting the action evaluator'
		during: [ self buildAndStartActionEvaluator ]
]

{ #category : #'private - activation/deactivation' }
CosmosApplication >> basicStop [

	self
		logAsInfo: 'Stopping the action evaluator' 
		during: [ actionEvaluator stop ];
		logAsInfo: 'Stopping the periodical scheduler' 
		during: [ periodicalScheduler stop ];
		logAsInfo: 'Stopping the RESTful API' 
		during: [ api stop ];
		logAsInfo: 'Shutting down cosmos' 
		during: [ cosmos shutDown ].
	super basicStop
]

{ #category : #'private - activation/deactivation' }
CosmosApplication >> buildAndStartActionEvaluator [

	actionEvaluator := ActionEvaluator
		evaluatingActionsFrom: pendingActionsQueue
		using: (ActionEvaluatorConfiguration workingWith: SystemTimeSource new)
		registeringEvaluationsInto: actionEvaluationsQueue.

	actionEvaluator start
	

]

{ #category : #'private - activation/deactivation' }
CosmosApplication >> buildAndStartCosmos [

	cosmos := CompositeSystem new.

	cosmos
		register: (TimeSystem using: SystemTimeSource new);
		register: EventNotificationSystem new;
		register: MetadataSystem new;
		register: (IdentifierSystem using: UUIDProvider new);
		register: TimestampingSystem new;
		register: DataStreamManagementSystem new;
		register: (TriggerManagementSystem enqueuingActionsInto: pendingActionsQueue);
		register: ActionManagementSystem new;
		register: (ActionEvaluationSystem registeringFrom: actionEvaluationsQueue);
		register: CommandManagementSystem new.
		
	cosmos startUp
]

{ #category : #'private - activation/deactivation' }
CosmosApplication >> buildAndStartRESTfulAPI [

	api := HTTPBasedRESTfulAPI 
		configuredBy: self apiConfiguration 
		installing: { 
			       ( DataStreamsRESTfulController workingWith: cosmos ).
			       ( DataPointsRESTfulController workingWith: cosmos ).
			       ( CommandsRESTfulController workingWith: cosmos ).
			       ( ActionsRESTfulController workingWith: cosmos ).
			       ( ActionEvaluationsRESTfulController workingWith: cosmos ).
			       ( TriggersRESTfulController workingWith: cosmos ) }.

	[ 
	LaunchpadLogRecord emitInfo: 'Configuring error handlers' during: [ 
		api
			on: Error addErrorHandler: [ :error | 
				self stackTraceDumper dumpStackTraceFor: error.
				TeaResponse serverError
					body: error messageText;
					yourself
				];
			on: Exit addErrorHandler: [ :exit | 
			exit isSuccess then: [ self stop ].
			exit pass
			]
		]
	] unless: self isDebugModeEnabled.

	api beCORSAwareAllowing: self allowedOrigins.

	api
		install;
		start
]

{ #category : #'private - activation/deactivation' }
CosmosApplication >> buildAndStartScheduler [

	periodicalScheduler := PeriodicalScheduler usingDefaultScheduler.

	self timePeriodsToSchedule do: [ :timePeriod | 
		| task |

		task := Task named: ( 'Notify every <1p>' expandMacrosWith: timePeriod ) do: [ 
			        ( cosmos systemImplementing: #EventNotificationSystemInterface ) notifySubscribersTo:
				        ( TickEvent of: timePeriod )
			        ].

		periodicalScheduler schedule: task toBeExecutedEvery: timePeriod
		].

	periodicalScheduler start
]

{ #category : #logging }
CosmosApplication >> logAsInfo: aMessage during: aBlock [

	LaunchpadLogRecord emitInfo: aMessage during: aBlock
]

{ #category : #'error handling' }
CosmosApplication >> stackTraceDumper [

	^ StackTraceBinarySerializer on: [ :dumpAction | 
		  self class fileReferenceToDumpStackTrace binaryWriteStreamDo: dumpAction ]
]

{ #category : #'private - accessing' }
CosmosApplication >> timePeriodsToSchedule [

	^ {(TimeUnits second with: 10).
	(TimeUnits minute with: 1).
	(TimeUnits minute with: 10).
	(TimeUnits hour with: 1)}
]
