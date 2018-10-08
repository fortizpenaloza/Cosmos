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

	<ignoreForCoverage>
	^ 'Install Cosmos and its API'
]

{ #category : #activation }
CosmosCommandLineHandler >> activate [

	self activateHelp
		ifTrue: [ ^ self ].

	Smalltalk logFileName: self logFileName.

	[ self
		logToStdout: '[INFO] Installing cosmos'
		during: [ self
				buildAndStartCosmos;
				buildAndStartCosmosAPI;
				buildAndStartScheduler ] ]
		on: Error
		do: [ :signal | 
			self dumpStackAndReport: signal.
			self exitFailure ]
]

{ #category : #'private - activation' }
CosmosCommandLineHandler >> addAllowOriginHeaderTo: aResponse ifOriginAt: aRequest matchesAny: allowedOrigins [

	allowedOrigins
		detect: [ :origin | origin = (aRequest headers at: 'Origin') ]
		ifFound: [ :allowedOrigin | aResponse headers at: 'Access-Control-Allow-Origin' put: allowedOrigin ]
		ifNone: [ "do nothing" ]
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> allowedOrigins [

	<ignoreForCoverage>
	^ self
		optionAt: 'allowed-origins'
		ifPresent: [ :string | string substrings: ',' ]
		ifAbsent: [ OrderedCollection new ]
]

{ #category : #'private - activation' }
CosmosCommandLineHandler >> buildAndStartCosmos [

	<ignoreForCoverage>
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

	<ignoreForCoverage>
	| teapot configurator |

	teapot := self teapot.
	configurator := ReflectiveRoutesConfigurator appliedTo: teapot.

	configurator
		addRoutesOf: (DataWebService workingWith: cosmos);
		addRoutesOf: (CommandsWebService workingWith: cosmos);
		addRoutesOf: (ActionsWebService workingWith: cosmos).

	(TriggersAPIInstaller toInstallOn: teapot workingWith: cosmos) install.

	self configureAllowOriginAfterFilterOn: teapot.
	self configureExceptionHandlerOn: teapot.

	teapot start
]

{ #category : #'private - activation' }
CosmosCommandLineHandler >> buildAndStartScheduler [

	<ignoreForCoverage>
	| scheduler tenSeconds oneMinute tenMinutes oneHour |

	tenSeconds := TimeUnits second with: 10.
	oneMinute := TimeUnits minute with: 1.
	tenMinutes := TimeUnits minute with: 10.
	oneHour := TimeUnits hour with: 1.

	scheduler := self periodicalScheduler.

	{tenSeconds.
	oneMinute.
	tenMinutes.
	oneHour}
		do: [ :timeInterval | 
			| task |

			task := Task
				named: ('Notify every <1p>' expandMacrosWith: timeInterval)
				do: [ (cosmos systemImplementing: #EventNotificationSystemInterface)
						notifySubscribersTo: (TickEvent of: timeInterval) ].

			scheduler schedule: task toBeExecutedEvery: timeInterval ].

	scheduler start
]

{ #category : #'private - activation' }
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
		when: [ :request | request headers includesKey: 'Origin' ]
]

{ #category : #'private - activation' }
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
						yourself ];
		exception: Error -> [ :signal :request | self dumpStackAndReport: signal ]
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> defaultPortNumber [

	^ 8080
]

{ #category : #'private - logging' }
CosmosCommandLineHandler >> dumpStackAndReport: aSignal [

	^ self
		logToStderr:
			('[ERROR] Dumping stack due to unexpected error: <1s>'
				expandMacrosWith: aSignal messageText)
		during: [ | serializer |

			serializer := FLSerializer newDefault.
			serializer analyzer
				when: [ :object | object class isObsolete ]
				substituteBy: [ :object | nil ].

			serializer serialize: thisContext toFileNamed: self stackDumpFileName ]
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> isDebugModeEnabled [

	<ignoreForCoverage>
	^ self hasOption: 'debug-mode'
]

{ #category : #'private - logging' }
CosmosCommandLineHandler >> logFileName [

	^ './logs/cosmos-<1s>.log'
		expandMacrosWith: (DateAndTime current printString copyReplaceAll: ':' with: '.')
]

{ #category : #'private - logging' }
CosmosCommandLineHandler >> logToStderr: aString [

	self stderr
		nextPutAll: ('[<1p>] <2s>' expandMacrosWith: DateAndTime current with: aString);
		lf;
		flush
]

{ #category : #'private - logging' }
CosmosCommandLineHandler >> logToStderr: aString during: aBlock [

	self logToStderr: aString.
	[ aBlock value.
	self logToStderr: ('<1s>... [OK]' expandMacrosWith: aString) ]
		ifCurtailed: [ self logToStderr: ('<1s>... [FAILED]' expandMacrosWith: aString) ]
]

{ #category : #'private - logging' }
CosmosCommandLineHandler >> logToStdout: aString [

	self stdout
		nextPutAll: ('[<1p>] <2s>' expandMacrosWith: DateAndTime current with: aString);
		lf;
		flush
]

{ #category : #'private - logging' }
CosmosCommandLineHandler >> logToStdout: aString during: aBlock [

	self logToStdout: aString.
	[ aBlock value.
	self logToStdout: ('<1s>... [OK]' expandMacrosWith: aString) ]
		ifCurtailed: [ self logToStdout: ('<1s>... [FAILED]' expandMacrosWith: aString) ]
]

{ #category : #'private - options' }
CosmosCommandLineHandler >> optionNamed: aName defaultingTo: anObject [

	^ self optionAt: aName ifAbsent: [ anObject ]
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> periodicalScheduler [

	^ PeriodicalScheduler workingWith: DelayExperimentalSemaphoreScheduler new
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> portNumber [

	| portNumber |

	portNumber := self
		optionNamed: 'port'
		defaultingTo: self defaultPortNumber.

	^ portNumber asNumber
]

{ #category : #'private - logging' }
CosmosCommandLineHandler >> stackDumpFileName [

	^ './logs/cosmos-stack-<1s>.fuel'
		expandMacrosWith: (DateAndTime current printString copyReplaceAll: ':' with: '.')
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> teapot [

	<ignoreForCoverage>
	^ Teapot
		configure:
			{(#port -> self portNumber).
			(#debugMode -> self isDebugModeEnabled)}
]
