Class {
	#name : #CosmosCommandLineHandler,
	#superclass : #CommandLineHandler,
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

	^ 'Install Cosmos and its API'
]

{ #category : #activation }
CosmosCommandLineHandler >> activate [

	self
		buildAndStartCosmos;
		buildAndStartCosmosAPI;
		buildAndStartScheduler
]

{ #category : #'private-activation' }
CosmosCommandLineHandler >> buildAndStartCosmos [

	| builder |

	builder := CompositeSystemBuilder new.
	builder
		add: (TimeSystem using: SystemTimeSource new);
		add: EventNotificationSystem new;
		add: DataManagementSystem new;
		add: TriggerManagementSystem new;
		add: ActionManagementSystem new;
		add: CommandManagementSystem new;
		yourself.

	cosmos := builder build.
	
	cosmos startUp
]

{ #category : #'private-activation' }
CosmosCommandLineHandler >> buildAndStartCosmosAPI [

	| server |

	server := self teapot.
	
	(DataAPIInstaller toInstallOn: server workingWith: cosmos) install.
	(TriggersAPIInstaller toInstallOn: server workingWith: cosmos) install.
	(ActionsAPIInstaller toInstallOn: server workingWith: cosmos) install.

	server
		exception:
			HTTPClientError
				-> [ :signal :request | 
					(ZnResponse statusCode: signal tag)
						entity: (ZnEntity json: signal messageText);
						yourself ].

	server start
]

{ #category : #'private-activation' }
CosmosCommandLineHandler >> buildAndStartScheduler [

	| scheduler tenSecondsNotification oneMinuteNotification tenMinutesNotification |

	tenSecondsNotification := Task
		named: 'Notify every 10 seconds'
		do: [ (cosmos systemImplementing: #EventNotificationSystemInterface)
				notifySubscribersTo: (TickEvent of: (TimeUnits second with: 10)) ].

	oneMinuteNotification := Task
		named: 'Notify every 1 minute'
		do: [ (cosmos systemImplementing: #EventNotificationSystemInterface)
				notifySubscribersTo: (TickEvent of: (TimeUnits minute with: 1)) ].

	tenMinutesNotification := Task
		named: 'Notify every 10 minutes'
		do: [ (cosmos systemImplementing: #EventNotificationSystemInterface)
				notifySubscribersTo: (TickEvent of: (TimeUnits minute with: 10)) ].

	scheduler := self periodicalScheduler.
	scheduler
		schedule: oneMinuteNotification
		toBeExecutedEvery: (TimeUnits minute with: 1).

	scheduler
		schedule: tenMinutesNotification
		toBeExecutedEvery: (TimeUnits minute with: 10).

	scheduler start
]

{ #category : #'private-accessing' }
CosmosCommandLineHandler >> periodicalScheduler [

	^ PeriodicalScheduler
		workingWith: DelayExperimentalSemaphoreScheduler new
]

{ #category : #'private-accessing' }
CosmosCommandLineHandler >> teapot [

	| port debugMode |

	port := self
		optionAt: 'port'
		ifPresent: [ :string | string asNumber ]
		ifAbsent: [ 8080 ].
	debugMode := self hasOption: 'debug-mode'.

	^ Teapot
		configure:
			{(#port -> port).
			(#debugMode -> debugMode)}
]
