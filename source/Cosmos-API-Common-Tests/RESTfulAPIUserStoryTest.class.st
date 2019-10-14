Class {
	#name : #RESTfulAPIUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'api'
	],
	#category : #'Cosmos-API-Common-Tests'
}

{ #category : #'private - accessing' }
RESTfulAPIUserStoryTest >> baseUrl [

	^ 'http://localhost' asUrl port: self port
]

{ #category : #running }
RESTfulAPIUserStoryTest >> checkPortAvailability [

	[ | socket |

	socket := ZnNetworkingUtils serverSocketOn: self port.
	socket close
	]
		on: Error
		do: [ :error | self fail: ( 'Port <1p> is not available' expandMacrosWith: self port ) ]
]

{ #category : #running }
RESTfulAPIUserStoryTest >> controllersToInstall [

	self subclassResponsibility 
]

{ #category : #'private - accessing' }
RESTfulAPIUserStoryTest >> identifierProvider [

	^ UUIDProvider new
]

{ #category : #'private - accessing' }
RESTfulAPIUserStoryTest >> newClient [

	^ ZnClient new
		beOneShot;
		enforceHttpSuccess: true;
		yourself
]

{ #category : #'private - accessing' }
RESTfulAPIUserStoryTest >> port [

	^ 9999
]

{ #category : #running }
RESTfulAPIUserStoryTest >> setUp [

	super setUp.
	self setUpAPIServer
]

{ #category : #running }
RESTfulAPIUserStoryTest >> setUpAPIServer [

	self checkPortAvailability.
	api := HTTPBasedRESTfulAPI
		configuredBy:
			{( #port -> self port ).
			( #serverUrl -> self baseUrl )}
		installing: self controllersToInstall.
	api
		on: Error
		addErrorHandler: [ :error :request | Processor activeProcess debug: error signalerContext title: 'lets see' ].
	api
		install;
		start
]

{ #category : #'private - accessing' }
RESTfulAPIUserStoryTest >> systemDateTime [

	^ DateTime 
		date: October first , 2014 
		timeOfDay: TimeOfDay noon 
		zone: TimeZones buenosAires
]

{ #category : #running }
RESTfulAPIUserStoryTest >> tearDown [

	api ifNotNil: [ api stop ].
	api := nil.
	super tearDown
]
