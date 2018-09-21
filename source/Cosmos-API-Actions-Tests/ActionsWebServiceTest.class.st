Class {
	#name : #ActionsWebServiceTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'interface'
	],
	#category : #'Cosmos-API-Actions-Tests'
}

{ #category : #accessing }
ActionsWebServiceTest >> actionJsonVersion1dot0dot0MimeType [

	^ ZnMimeType fromString: 'application/vnd.cosmos.action+json; version=1.0.0'
]

{ #category : #accessing }
ActionsWebServiceTest >> applicationJsonVersion1dot0dot0 [

	^ ZnMimeType fromString: 'application/json;version=1.0.0'
]

{ #category : #accessing }
ActionsWebServiceTest >> dateTimeFormattedAsISO8601 [

	^ ISO8601DateTimeFormatter usingExtendedFormat
		format: self systemDateTime
]

{ #category : #accessing }
ActionsWebServiceTest >> getActionsHttpRequest [

	^ (ZnRequest get: 'http://COSMOS_URL/v1/actions') setAccept: self actionJsonVersion1dot0dot0MimeType
]

{ #category : #running }
ActionsWebServiceTest >> setUp [

	super setUp.

	interface := ActionsWebService workingWith: rootSystem
]

{ #category : #running }
ActionsWebServiceTest >> setUpRequirements [

	super
		setUpRequirements;
		requireActionManagementSystem.
 
]

{ #category : #tests }
ActionsWebServiceTest >> testCreatingAction [

	| response |

	self assert: self actionManagementSystem actions isEmpty.

	response := interface
		createActionBasedOn: ((ZnRequest post: 'http://COSMOS_URL/actions')
				entity:
					(ZnEntity
						with: '{
  "name": "List DNS records",
  "http_request": {
    "request_line": {
      "method": "GET",
      "url": "https://api.cloudflare.com/client/v4/zones/77527abc25e3d9004fd943209c925e4e/dns_records",
      "version": "HTTP/1.1"
    },
    "headers": [
      {
        "key": "X-Auth-Email",
        "value": "patchinko@gmail.com"
      },
      {
        "key": "X-Auth-Key",
        "value": "93b0b7a99ad1fc123d0d2b6508849db7e6414"
      }
    ]
  }
}'
						type: self applicationJsonVersion1dot0dot0)).
						
	self
		assert: response code equals: 201;
		assert: (response headers includesKey: 'Location').

	self
		withTheOnlyOneIn: self actionManagementSystem actions
		do: [ :action | 
			self
				assert: action name equals: 'List DNS records' ]
]

{ #category : #tests }
ActionsWebServiceTest >> testDeregistration [

	self assert: self actionManagementSystem actions isEmpty.

	interface
		registerHandling:
			'{
		"name" : "List DNS records",
		"request" : { 
			"request_line" : { 
				"method" : "GET",
				"url" : "https://api.cloudflare.com/client/v4/zones/77527abc25e3d9004fd943209c925e4e/dns_records",
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

{ #category : #tests }
ActionsWebServiceTest >> testQueringActions [

	| response action |

	action := Action
		named: 'Get DNS zones'
		evaluating:
			(SendHttpRequestPolicy
				sending:
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
							(ZnHeaders
								withAll:
									{('X-Auth-Email' -> 'patchinko@gmail.com').
									('X-Auth-Key' -> '93b0b7a99ad1fc123d0d2b6508849db7e64')} asDictionary);
						yourself)).

	self actionManagementSystem register: action.

	action := Action
		named: 'Add DNS zone'
		evaluating:
			(SendHttpRequestPolicy
				sending:
					(ZnRequest new
						requestLine:
							(ZnRequestLine empty
								method: #POST;
								uri:
									'https://api.cloudflare.com/client/v4/zones/77527abc25e3d9004fd943209c925e4e/dns_records'
										asZnUrl;
								version: ZnConstants defaultHTTPVersion;
								yourself);
						headers:
							(ZnHeaders
								withAll:
									{('X-Auth-Email' -> 'patchinko@gmail.com').
									('X-Auth-Key' -> '93b0b7a99ad1fc123d0d2b6508849db7e64')} asDictionary);
						yourself)).

	response := interface actionsFor: self getActionsHttpRequest.

	self
		assert: response code equals: 200;
		assert: response contents
			equals:
			('[{"name":"Get DNS zones","http_request":{"request_line":{"method":"GET","url":"https://api.cloudflare.com/client/v4/zones/77527abc25e3d9004fd943209c925e4e/dns_records","version":"HTTP/1.1"},"headers":[{"key":"X-Auth-Email","value":"patchinko@gmail.com"},{"key":"X-Auth-Key","value":"93b0b7a99ad1fc123d0d2b6508849db7e64"}]}}]' expandMacrosWith: self dateTimeFormattedAsISO8601)
]
