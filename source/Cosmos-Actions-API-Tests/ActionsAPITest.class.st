Class {
	#name : #ActionsAPITest,
	#superclass : #SystemBasedUserStoryTest,
	#category : 'Cosmos-Actions-API-Tests'
}

{ #category : #'initialize-release' }
ActionsAPITest >> setUpRequirements [

	super
		setUpRequirements;
		requireActionManagementSystem.
 
]

{ #category : #'initialize-release' }
ActionsAPITest >> testDeregistration [

	| interface |

	interface := ActionsAPI
		workingWith: (ActionsAPIContext workingWith: rootSystem).

	self assert: self actionManagementSystem actions isEmpty.

	interface
		registerFrom:
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

	| interface response |

	interface := ActionsAPI workingWith: (ActionsAPIContext workingWith: rootSystem).

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

	response := interface actions.

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

	| interface response |

	interface := ActionsAPI
		workingWith: (ActionsAPIContext workingWith: rootSystem).
		
	self assert: self actionManagementSystem actions isEmpty.

	response := interface
		registerFrom:
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
