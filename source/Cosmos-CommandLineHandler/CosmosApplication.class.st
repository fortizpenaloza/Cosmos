Class {
	#name : #CosmosApplication,
	#superclass : #LaunchpadApplication,
	#instVars : [
		'pendingActionsQueue',
		'actionEvaluationsQueue',
		'cosmos'
	],
	#category : #'Cosmos-CommandLineHandler'
}

{ #category : #accessing }
CosmosApplication class >> commandName [

	^ 'cosmos'
]

{ #category : #accessing }
CosmosApplication class >> configurationParameters [

	^ Array
		  with: ( OptionalConfigurationParameter
				    named: 'hostname'
				    describedBy: 'The host where the cosmos RESTful API will be available'
				    defaultingTo: 'localhost' )
		  with: ( OptionalConfigurationParameter
				    named: 'port'
				    describedBy: 'The port where the cosmos RESTful API will be available'
				    defaultingTo: 57001
				    convertingWith: #asNumber )
		  with: ( MandatoryConfigurationParameter
				    named: 'allowed-origins'
				    describedBy: 'The allowed origins'
				    convertingWith: [ :string | ( ( string substrings: ',' ) collect: #trim ) collect: #asUrl ] )
]

{ #category : #accessing }
CosmosApplication class >> description [

	^ 'Cosmos application'
]

{ #category : #accessing }
CosmosApplication class >> version [

	^ 'v1.0.0'
]

{ #category : #'private - activation/deactivation' }
CosmosApplication >> basicStartWithin: context [

	LogRecord emitInfo: 'Creating pending evaluation actions queue' during: [ pendingActionsQueue := AtomicSharedQueue new ].
	LogRecord emitInfo: 'Creating action evaluation queue' during: [ actionEvaluationsQueue := AtomicSharedQueue new ].
	LogRecord emitInfo: 'Building and starting cosmos' during: [ self buildAndStartCosmos ].
	LogRecord emitInfo: 'Building and starting RESTful API' during: [ self buildAndStartCosmosAPI ].
	LogRecord emitInfo: 'Building and starting the periodical scheduler' during:  [ self buildAndStartScheduler ].
	LogRecord emitInfo: 'Building and starting the action evaluator' during:  [ self buildAndStartActionEvaluator ].
	
]

{ #category : #'private - building evaluator' }
CosmosApplication >> buildAndStartActionEvaluator [

	| evaluator |

	evaluator := ActionEvaluator
		evaluatingActionsFrom: pendingActionsQueue
		using: (ActionEvaluatorConfiguration workingWith: SystemTimeSource new)
		registeringEvaluationsInto: actionEvaluationsQueue.

	evaluator start
	

]

{ #category : #'private - building cosmos system' }
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

{ #category : #'private - building cosmos API' }
CosmosApplication >> buildAndStartCosmosAPI [

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
			(ActionEvaluationsRESTfulController workingWith: cosmos).
			(TriggersRESTfulController workingWith: cosmos)}..
			
	api
		on: self exceptionsToHandle
		addErrorHandler: [ :signal :request | self class dumpStackAndReport: signal ].
		
	api beCORSAwareAllowing: self allowedOrigins.

	api
		install;
		start
]

{ #category : #'private - building scheduler' }
CosmosApplication >> buildAndStartScheduler [

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

{ #category : #'private - building scheduler' }
CosmosApplication >> periodicalScheduler [

	^ PeriodicalScheduler usingDefaultScheduler
]

{ #category : #'error handling' }
CosmosApplication >> stackTraceDumper [

	^ NullStackTraceDumper new
]

{ #category : #'private - building scheduler' }
CosmosApplication >> timePeriodsToSchedule [

	^ {(TimeUnits second with: 10).
	(TimeUnits minute with: 1).
	(TimeUnits minute with: 10).
	(TimeUnits hour with: 1)}
]
