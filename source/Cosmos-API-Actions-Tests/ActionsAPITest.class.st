Class {
	#name : #ActionsAPITest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'interface'
	],
	#category : #'Cosmos-API-Actions-Tests'
}

{ #category : #accessing }
ActionsAPITest >> actionJsonVersion1dot0dot0MimeType [

	^ ZnMimeType fromString: 'application/vnd.cosmos.action+json; version=1.0.0'
]

{ #category : #accessing }
ActionsAPITest >> getActionsHttpRequest [

	^ (ZnRequest get: 'http://COSMOS_URL/v1/actions') setAccept: self actionJsonVersion1dot0dot0MimeType
]

{ #category : #'initialize-release' }
ActionsAPITest >> setUp [

	super setUp.

	interface := (ActionsAPIInstaller toInstallOn: Teapot on workingWith: rootSystem) install
]

{ #category : #'initialize-release' }
ActionsAPITest >> setUpRequirements [

	super
		setUpRequirements;
		requireActionManagementSystem.
 
]

{ #category : #'initialize-release' }
ActionsAPITest >> testDeregistration [

	self assert: self actionManagementSystem actions isEmpty.

	interface
		registerHandling:
			'{
		"name" : "List DNS records",
		"request" : { 
			"request_line" : { 
				"method" : "GET",
				"URL" : "https://api.cloudflare.com/client/v4/zones/77527abc25e3d9004fd943209c925e4e/dns_records",
				"version" : "HTTP/1.1"
			},
		"headers" : [
			{
				"key" : "X-Auth-Email",
				"value" : "patchinko@gmail.com"
			},
			{
				"key" : "X-Auth-Key",
				"value" : "93b0b7a99ad1fc123d0d2b6508849db7e6414"
			}
		]
	}
}'.
	
	self deny: self actionManagementSystem actions isEmpty.
	
	interface
		deregisterNamed: 'List DNS records'.

	self assert: self actionManagementSystem actions isEmpty.
		
]

{ #category : #'initialize-release' }
ActionsAPITest >> testQueringActions [

	| response |

	(rootSystem systemImplementing: #ActionManagementSystemInterface)
		registerNamed: 'List DNS records'
		toEvaluate:
			(ZnRequest new
				requestLine:
					(ZnRequestLine empty
						method: #GET;
						uri:
							'https://api.cloudflare.com/client/v4/zones/77527abc25e3d9004fd943209c925e4e/dns_records'
								asZnUrl;
						version: ZnConstants defaultHTTPVersion;
						yourself);
				headers:
					{('X-Auth-Email' -> 'patchinko@gmail.com').
					('X-Auth-Key' -> '93b0b7a99ad1fc123d0d2b6508849db7e64')};
				yourself).

	response := interface actionsFor: self getActionsHttpRequest.

	self
		assert: response code equals: 200;
		assert: response contents
			equals:
			('[
	{
		"name" : "List DNS records",
		"created_on" : "2015-09-06T12:00:00<1p>",
		"http_request" : {
			"request_line" : {
				"method" : "GET",
				"URL" : "https://api.cloudflare.com/client/v4/zones/77527abc25e3d9004fd943209c925e4e/dns_records",
				"version" : "HTTP/1.1"
			},
			"headers" : [
				{
					"key" : "X-Auth-Email",
					"value" : "patchinko@gmail.com"
				},
				{
					"key" : "X-Auth-Key",
					"value" : "93b0b7a99ad1fc123d0d2b6508849db7e64"
				}
			]
		}
	}
]' expandMacrosWith: TimeZones local offset)
]

{ #category : #'initialize-release' }
ActionsAPITest >> testRegistration [

	| response |
	
	self assert: self actionManagementSystem actions isEmpty.

	response := interface
		registerHandling:
			'{
		"name" : "List DNS records",
		"request" : { 
			"request_line" : { 
				"method" : "GET",
				"URL" : "https://api.cloudflare.com/client/v4/zones/77527abc25e3d9004fd943209c925e4e/dns_records",
				"version" : "HTTP/1.1"
			},
		"headers" : [
			{
				"key" : "X-Auth-Email",
				"value" : "patchinko@gmail.com"
			},
			{
				"key" : "X-Auth-Key",
				"value" : "93b0b7a99ad1fc123d0d2b6508849db7e6414"
			}
		]
	}
}'.

	self
		assert: response code equals: 201;
		assert: (response headers includesKey: 'Location').
		
	self
		withTheOnlyOneIn: self actionManagementSystem actions
		do: [ :action | self assert: action name equals: 'List DNS records';
				assert: action creationDateTime equals: self timeSystem dateTime ]
]
