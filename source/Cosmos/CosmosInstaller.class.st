Class {
	#name : #CosmosInstaller,
	#superclass : #Object,
	#category : 'Cosmos'
}

{ #category : #installing }
CosmosInstaller >> buildSystem [

	| builder system |

	builder := CompositeSystemBuilder new.
	builder
		add: (TimeSystem using: SystemTimeSource new);
		add: EventNotificationSystem new;
		add: DataManagementSystem new;
		add: TriggerManagementSystem new;
		add: ActionManagementSystem new;
		add: CommandManagementSystem new;
		yourself.

	system := builder build.
	^ system
]

{ #category : #installing }
CosmosInstaller >> install [

	| cosmos scheduler task |

	cosmos := self buildSystem.
	cosmos startUp.

	self installAPIsOn: cosmos.

	task := Task
		named: 'Notify 10 seconds has passed'
		do: [ (cosmos systemImplementing: #EventNotificationSystemInterface)
				notifySubscribersTo: (TickEvent of: (TimeUnits second with: 10)) ].

	scheduler := PeriodicalScheduler workingWith: DelayExperimentalSemaphoreScheduler new.
	scheduler schedule: task toBeExecutedEvery: (TimeUnits second with: 10).

	scheduler start.
	
	^ cosmos
]

{ #category : #installing }
CosmosInstaller >> installAPIsOn: system [

	| server |

	server := self teapot.

	(DataAPIInstaller toWorkWith: system on: server) install.
	(TriggersAPIInstaller toWorkWith: system on: server) install.
	(ActionsAPIInstaller toWorkWith: system on: server) install.

	server
		exception:
			HTTPClientError
				-> [ :signal :request | 
					(ZnResponse statusCode: signal tag)
						entity: (ZnEntity json: signal messageText);
						yourself ].
					
	server start
]

{ #category : #installing }
CosmosInstaller >> teapot [

	^ Teapot
		configure:
			{(#port -> 8080).
			(#debugMode -> true)}
]
