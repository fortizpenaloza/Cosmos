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

	<ignoreForCoverage>
	self activateHelp
		ifTrue: [ ^ self ].

	self
		buildAndStartCosmos;
		buildAndStartCosmosAPI;
		buildAndStartScheduler
]

{ #category : #'private-activation' }
CosmosCommandLineHandler >> buildAndStartCosmos [

	<ignoreForCoverage>
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

	<ignoreForCoverage>
	| server |

	server := self teapot.

	(DataAPIInstaller toInstallOn: server workingWith: cosmos) install.
	(TriggersAPIInstaller toInstallOn: server workingWith: cosmos) install.
	(ActionsAPIInstaller toInstallOn: server workingWith: cosmos) install.

	server
		after:
			'/*'
				-> [ :request :response | response headers at: 'Access-Control-Allow-Origin' put: '*' ];
		exception:
			HTTPClientError
				-> [ :signal :request | 
					| error |

					error := Dictionary new.

					error
						at: #code put: signal tag;
						at: #message put: signal messageText;
						yourself.

					(ZnResponse statusCode: signal tag)
						headers:
							(ZnHeaders defaultResponseHeaders
								at: 'Access-Control-Allow-Origin' put: '*';
								yourself);
						entity: (ZnEntity json: (STONJSON toStringPretty: error));
						yourself ].

	server start
]

{ #category : #'private-activation' }
CosmosCommandLineHandler >> buildAndStartScheduler [

	<ignoreForCoverage>
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
	scheduler schedule: oneMinuteNotification toBeExecutedEvery: (TimeUnits minute with: 1).

	scheduler
		schedule: tenMinutesNotification
		toBeExecutedEvery: (TimeUnits minute with: 10).

	scheduler start
]

{ #category : #'private-accessing' }
CosmosCommandLineHandler >> periodicalScheduler [

	<ignoreForCoverage>
	^ PeriodicalScheduler workingWith: DelayExperimentalSemaphoreScheduler new
]

{ #category : #'private-accessing' }
CosmosCommandLineHandler >> teapot [

	<ignoreForCoverage>
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
