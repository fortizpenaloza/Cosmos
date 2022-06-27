"
A CosmosCommandLineHandlerTest is a test class for testing the behavior of CosmosCommandLineHandler
"
Class {
	#name : #CosmosApplicationTest,
	#superclass : #TestCase,
	#instVars : [
		'application'
	],
	#category : #'Cosmos-CommandLineHandler-Tests'
}

{ #category : #tests }
CosmosApplicationTest >> runCase [

	self shouldnt: [ super runCase ] raise: Exit
]

{ #category : #tests }
CosmosApplicationTest >> setUp [ 

	super setUp.
	CosmosApplication logsDirectory ensureCreateDirectory 
]

{ #category : #running }
CosmosApplicationTest >> tearDown [ 

	application ifNotNil: #stop.
	CosmosApplication logsDirectory ensureDeleteAll.  
	super tearDown
]

{ #category : #tests }
CosmosApplicationTest >> testActivationWithAllArguments [

	| logger arguments |

	logger := MemoryLogger new.
	arguments := { '--allowed-origins=https://cosmos.com' }.

	self
		shouldnt: [ 
			logger runDuring: [ 
				String streamContents: [ :stream | 
					| context rootCommand |

					rootCommand := LaunchpadRootCommand new.
					context := LaunchpadCommandLineProcessingContext
						           handling: ( CommandLineArguments withArguments: { 
									             'launchpad'.
									             'start'.
									             '--debug-mode'.
									             CosmosApplication commandName } , arguments )
						           writingTo: stream.
					self assert:
						( rootCommand canHandle: ( context nextCommandLineArgumentIfNone: [ self fail ] ) ).
					rootCommand evaluateWithin: context.
					application := LaunchpadApplication currentlyRunning .
					]
				]
			]
		raise: Exit.
		
	self assert: application configuration publicURL equals: 'https://localhost/' asUrl;
		assert: application configuration port equals: 57001;
		assert: application configuration allowedOrigins hasTheSameElementsInTheSameOrderThat: { 'https://cosmos.com' asUrl }.
]

{ #category : #tests }
CosmosApplicationTest >> testCommandName [

	self assert: CosmosApplication commandName equals: 'cosmos'
]

{ #category : #tests }
CosmosApplicationTest >> testConfigurationParameters [

	| parameters parameter |

	parameters := CosmosApplication configurationParameters.

	self assert: parameters size equals: 3.

	parameter := parameters first.
		
	self
		assert: parameter name equals: 'Public URL';
		assert: parameter summary equals: 'Public URL where the API is deployed. Used to create hypermedia links. Defaults to https://localhost/';
		assert: parameter commandLineArgumentName equals: 'public-url';
		assert: parameter environmentVariableName equals: 'PUBLIC_URL'.

	parameter := parameters second.
		
	self
		assert: parameter name equals: 'Port';
		assert: parameter summary equals: 'Listening port. Defaults to 57001';
		assert: parameter commandLineArgumentName equals: 'port';
		assert: parameter environmentVariableName equals: 'PORT'.

	parameter := parameters third.
		
	self
		assert: parameter name equals: 'Allowed origins';
		assert: parameter summary equals: 'List of allowed origins';
		assert: parameter commandLineArgumentName equals: 'allowed-origins';
		assert: parameter environmentVariableName equals: 'ALLOWED_ORIGINS'.
]

{ #category : #tests }
CosmosApplicationTest >> testDescription [

	self assert: CosmosApplication description equals: 'A Cosmos application'
]

{ #category : #tests }
CosmosApplicationTest >> testFileReferenceToDumpStackTrace [ 

	| segments |

	segments := CosmosApplication fileReferenceToDumpStackTrace asPath segments.
	self
		assert: segments size equals: 2;
		assert: segments first equals: 'logs';
		assert: (segments last beginsWith: CosmosApplication commandName);
		assert: (segments last endsWith: '.fuel')
]

{ #category : #tests }
CosmosApplicationTest >> testPrintHelpOn [

	| help |

	help := String streamContents: [ :stream | CosmosApplication printHelpOn: stream ].

	self assert: help equals: ('NAME
		cosmos [<1s>] - A Cosmos application
SYNOPSYS
		cosmos [--public-url=%<publicURL%>] [--port=%<port%>] --allowed-origins=%<allowedOrigins%>
PARAMETERS
		--public-url=%<publicURL%>
			Public URL where the API is deployed. Used to create hypermedia links. Defaults to https://localhost/.
		--port=%<port%>
			Listening port. Defaults to 57001.
		--allowed-origins=%<allowedOrigins%>
			List of allowed origins.
ENVIRONMENT
		PUBLIC_URL
			Public URL where the API is deployed. Used to create hypermedia links. Defaults to https://localhost/.
		PORT
			Listening port. Defaults to 57001.
		ALLOWED_ORIGINS
			List of allowed origins.
' expandMacrosWith: CosmosApplication version)
]

{ #category : #tests }
CosmosApplicationTest >> testStackTraceDumper [ 

	| dumper result |

	dumper := CosmosApplication new stackTraceDumper.

	result := [ 1 / 0 ] on: ZeroDivide
		          do: [ :zeroDivide | 
			          dumper dumpStackTraceFor: zeroDivide.
			          zeroDivide return: 5
			          ].
	self assert: result equals: 5
]
