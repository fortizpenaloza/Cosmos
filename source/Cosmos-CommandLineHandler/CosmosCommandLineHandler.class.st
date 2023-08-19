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
	#superclass : #AnObsoleteLaunchpadCommandLineHandler,
	#instVars : [
		'cosmos',
		'pendingActionsQueue',
		'actionEvaluationsQueue'
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
CosmosCommandLineHandler class >> logPrefix [

	^ 'cosmos'
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> allowedOrigins [

	^ self configuration at: 'allowed-origins'
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> baseUrl [

	^ ('http://' , self hostname) asUrl port: self port
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> hostname [

	^ self configuration at: 'hostname'
]

{ #category : #logging }
CosmosCommandLineHandler >> logAsInfo: aMessage during: aBlock [

	CurrentLogger value logAsInfo: aMessage during: aBlock
]

{ #category : #'private - accessing' }
CosmosCommandLineHandler >> port [

	^ self configuration at: 'port'
]
