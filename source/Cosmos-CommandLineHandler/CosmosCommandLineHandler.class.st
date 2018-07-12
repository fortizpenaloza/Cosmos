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
CosmosCommandLineHandler >> addAllowOriginHeaderTo: aResponse ifOriginAt: aRequest matchesAny: allowedOrigins [

	<ignoreForCoverage>
	[ allowedOrigins
		detect: [ :origin | origin = (aRequest headers at: 'Origin') ]
		ifFound: [ :allowedOrigin | aResponse headers at: 'Access-Control-Allow-Origin' put: allowedOrigin ]
		ifNone: [ "do nothing" ] ]
		on: KeyNotFound
		do: [ :signal | HTTPClientError signalBadRequest: 'Origin header expected not found' ]
]

{ #category : #'private-accessing' }
CosmosCommandLineHandler >> allowedOrigins [

	<ignoreForCoverage>
	^ self
		optionAt: 'allowed-origins'
		ifPresent: [ :string | string substrings: ',' ]
		ifAbsent: [ OrderedCollection new ]
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
	(TriggersAPIInstaller toInstallOn: server workingWith: cosmos)
		install.
	(ActionsAPIInstaller toInstallOn: server workingWith: cosmos) install.
	self configureAllowOriginAfterFilterOn: server.
	self configureExceptionHandlerOn: server.

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

{ #category : #'private-activation' }
CosmosCommandLineHandler >> configureAllowOriginAfterFilterOn: aServer [

	<ignoreForCoverage>
	aServer
		after:
			'/*'
				-> [ :request :response | 
					self
						addAllowOriginHeaderTo: response
						ifOriginAt: request
						matchesAny: self allowedOrigins.

					response ];
		when: [ :request | self methodIsNotSafeOf: request ]
]

{ #category : #'private-activation' }
CosmosCommandLineHandler >> configureExceptionHandlerOn: aServer [

	<ignoreForCoverage>
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
						yourself ]
]

{ #category : #'private-accessing' }
CosmosCommandLineHandler >> defaultPortNumber [

	<ignoreForCoverage>
	^ 8080
]

{ #category : #'private-accessing' }
CosmosCommandLineHandler >> isDebugModeEnabled [

	<ignoreForCoverage>
	^ self hasOption: 'debug-mode'
]

{ #category : #'private-activation' }
CosmosCommandLineHandler >> methodIsNotSafeOf: aRequest [

	"According to Hypertext Transfer Protocol version 1.1 GET and HEAD are safe methods that SHOULD NOT have the significance of taking an action other than retrieval"

	^ (#('HEAD' 'GET') includes: aRequest method) not
]

{ #category : #'private-accessing' }
CosmosCommandLineHandler >> periodicalScheduler [

	<ignoreForCoverage>
	^ PeriodicalScheduler workingWith: DelayExperimentalSemaphoreScheduler new
]

{ #category : #'private-accessing' }
CosmosCommandLineHandler >> portNumber [

	<ignoreForCoverage>
	^ self
		optionAt: 'port'
		ifPresent: [ :string | string asNumber ]
		ifAbsent: [ self defaultPortNumber ]
]

{ #category : #'private-accessing' }
CosmosCommandLineHandler >> teapot [

	<ignoreForCoverage>
	^ Teapot
		configure:
			{(#port -> self portNumber).
			(#debugMode -> self isDebugModeEnabled)}
]
