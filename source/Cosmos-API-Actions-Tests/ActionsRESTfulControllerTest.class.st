Class {
	#name : #ActionsRESTfulControllerTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'resourceController',
		'identifierSequence'
	],
	#category : #'Cosmos-API-Actions-Tests'
}

{ #category : #'private - media types' }
ActionsRESTfulControllerTest >> applicationJsonVersion1dot0dot0MediaType [

	^ 'application/json;version=1.0.0' asMediaType 
]

{ #category : #'private - accessing' }
ActionsRESTfulControllerTest >> baseUrl [

	^ 'https://tests.cosmos.com' asZnUrl
]

{ #category : #'private - accessing' }
ActionsRESTfulControllerTest >> dateTimeFormattedAsISO8601 [

	^ ISO8601DateTimeFormatter usingExtendedFormat
		format: self systemDateTime
]

{ #category : #'private - accessing' }
ActionsRESTfulControllerTest >> getDNSZonesIdentifier [
	
	^identifierSequence first
]

{ #category : #'private - accessing' }
ActionsRESTfulControllerTest >> httpRequestContext [

	^ HttpRequestContext new
]

{ #category : #'private - accessing' }
ActionsRESTfulControllerTest >> identifierProvider [

	^ SequentialIdentifierProvider providing: identifierSequence 
]

{ #category : #'test support' }
ActionsRESTfulControllerTest >> registerAddDNSZone [

	| action |

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
									('X-Auth-Key' -> '93b0b7a99ad1fc123d0d2b6508849db7e64')}
										asDictionary);
						yourself)).
	
	self actionManagementSystem register: action
]

{ #category : #'test support' }
ActionsRESTfulControllerTest >> registerGetDNSZones [

	| action |

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
									('X-Auth-Key' -> '93b0b7a99ad1fc123d0d2b6508849db7e64')}
										asDictionary);
						yourself)).

	self actionManagementSystem register: action
]

{ #category : #'private - requests' }
ActionsRESTfulControllerTest >> requestToGetActionIdentifiedBy: anIdentifier accepting: aMediaType [

	^ TeaRequest
		fromZnRequest:
			((ZnRequest get: (self urlForResourceIdentifiedBy: anIdentifier))
				setAccept: aMediaType;
				yourself)
		pathParams: {(#identifier -> anIdentifier)} asDictionary
]

{ #category : #'private - requests' }
ActionsRESTfulControllerTest >> requestToGetActions [

	^ (ZnRequest get: self resourceUrl)
		setAccept: self applicationJsonVersion1dot0dot0MediaType
]

{ #category : #'private - accessing' }
ActionsRESTfulControllerTest >> resourceUrl [

	^ self baseUrl / resourceController specification endpoint
	

]

{ #category : #running }
ActionsRESTfulControllerTest >> setUp [

	identifierSequence := {
	(UUID fromString: 'ab203809-4537-0d00-96a8-67bd07fa2cfc').
	(UUID fromString: 'c3e53a0a-4537-0d00-96a9-ad5f07fa2cfc')}.
	
	super setUp.

	resourceController := ActionsRESTfulController workingWith: rootSystem.
	resourceController serverUrl: self baseUrl asZnUrl.

]

{ #category : #running }
ActionsRESTfulControllerTest >> setUpRequirements [

	super
		setUpRequirements;
		requireActionManagementSystem.
 
]

{ #category : #tests }
ActionsRESTfulControllerTest >> testCreateAction [

	| response |

	self assert: self actionManagementSystem actions isEmpty.

	response := resourceController
		createActionBasedOn:
			((ZnRequest post: 'http://COSMOS_URL/actions')
				entity:
					(ZnEntity
						with:
							'{
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
						type: self applicationJsonVersion1dot0dot0MediaType))
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 201;
		assert: response location
			equals: 'https://tests.cosmos.com/actions/ab203809-4537-0d00-96a8-67bd07fa2cfc';
		assert: response contentType equals: self textPlainMediaType.

	self
		withTheOnlyOneIn: self actionManagementSystem actions
		do: [ :action | self assert: action name equals: 'List DNS records' ]
]

{ #category : #tests }
ActionsRESTfulControllerTest >> testDeleteAction [

	| action |

	self assert: self actionManagementSystem actions isEmpty.

	action := Action
		named: 'List DNS Records'
		evaluating: (SendHttpRequestPolicy sending: ZnRequest empty).

	self actionManagementSystem register: action.

	self deny: self actionManagementSystem actions isEmpty.

	resourceController
		deleteActionBasedOn:
			(TeaRequest
				fromZnRequest: (ZnRequest delete: 'List_DNS_Records')
				pathParams: {(#identifier -> identifierSequence first)} asDictionary )
		within: self httpRequestContext.

	self assert: self actionManagementSystem actions isEmpty
]

{ #category : #tests }
ActionsRESTfulControllerTest >> testGetAction [

	| response |

	self registerGetDNSZones.
	self registerAddDNSZone.

	response := resourceController
		getActionBasedOn: (self requestToGetActionIdentifiedBy: self getDNSZonesIdentifier accepting: self applicationJsonVersion1dot0dot0MediaType)
		within: self httpRequestContext.
	self
		assert: response code equals: 200; 
		assert: response contents
			equals:
			'{"name":"Get DNS zones","http_request":{"request_line":{"method":"GET","url":"https://api.cloudflare.com/client/v4/zones/77527abc25e3d9004fd943209c925e4e/dns_records","version":"HTTP/1.1"},"headers":[{"key":"X-Auth-Email","value":"patchinko@gmail.com"},{"key":"X-Auth-Key","value":"93b0b7a99ad1fc123d0d2b6508849db7e64"}]}}'
]

{ #category : #tests }
ActionsRESTfulControllerTest >> testGetActions [

	| response |

	self registerGetDNSZones.
	self registerAddDNSZone.

	response := resourceController
		getActionsBasedOn: self requestToGetActions
		within: self httpRequestContext.

	self
		assert: response code equals: 200;
		assert: response contents
			equals:
			'[{"name":"Get DNS zones","http_request":{"request_line":{"method":"GET","url":"https://api.cloudflare.com/client/v4/zones/77527abc25e3d9004fd943209c925e4e/dns_records","version":"HTTP/1.1"},"headers":[{"key":"X-Auth-Email","value":"patchinko@gmail.com"},{"key":"X-Auth-Key","value":"93b0b7a99ad1fc123d0d2b6508849db7e64"}]}},{"name":"Add DNS zone","http_request":{"request_line":{"method":"POST","url":"https://api.cloudflare.com/client/v4/zones/77527abc25e3d9004fd943209c925e4e/dns_records","version":"HTTP/1.1"},"headers":[{"key":"X-Auth-Email","value":"patchinko@gmail.com"},{"key":"X-Auth-Key","value":"93b0b7a99ad1fc123d0d2b6508849db7e64"}]}}]'
]

{ #category : #'private - media types' }
ActionsRESTfulControllerTest >> textPlainMediaType [

	^ 'text/plain;charset=utf-8' asMediaType
]

{ #category : #'private - accessing' }
ActionsRESTfulControllerTest >> urlForResourceIdentifiedBy: anIdentifier [

	^ self resourceUrl / anIdentifier printString asZnUrl
]
