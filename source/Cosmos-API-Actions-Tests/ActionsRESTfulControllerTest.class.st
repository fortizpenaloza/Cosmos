Class {
	#name : #ActionsRESTfulControllerTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'resourceController'
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

{ #category : #'private - expected results' }
ActionsRESTfulControllerTest >> getDNSZonesAsJSON [

	^ '{"name":"Get DNS zones","http_request":{"request_line":{"method":"GET","url":"https://api.cloudflare.com/client/v4/zones/77527abc25e3d9004fd943209c925e4e/dns_records","version":"HTTP/1.1"},"headers":[{"key":"X-Auth-Email","value":"patchinko@gmail.com"},{"key":"X-Auth-Key","value":"93b0b7a99ad1fc123d0d2b6508849db7e64"}]},"links":{"self":"https://tests.cosmos.com/actions/ab203809-4537-0d00-96a8-67bd07fa2cfc"}}'
]

{ #category : #'private - accessing' }
ActionsRESTfulControllerTest >> getDNSZonesIdentifier [

	^ UUID fromString: 'ab203809-4537-0d00-96a8-67bd07fa2cfc'
]

{ #category : #'private - accessing' }
ActionsRESTfulControllerTest >> httpRequestContext [

	^ HttpRequestContext new
]

{ #category : #'private - accessing' }
ActionsRESTfulControllerTest >> identifierProvider [

	^ SequentialIdentifierProvider providing: self identifierSequence 
]

{ #category : #'private - accessing' }
ActionsRESTfulControllerTest >> identifierSequence [

	^ {self getDNSZonesIdentifier.
	(UUID fromString: 'c3e53a0a-4537-0d00-96a9-ad5f07fa2cfc')}
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
ActionsRESTfulControllerTest >> requestToDeleteActionIdentifiedBy: anIdentifier [ 

	^ TeaRequest
		fromZnRequest: (self urlForResourceIdentifiedBy: anIdentifier)
		pathParams: {(#identifier -> anIdentifier)} asDictionary
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

	super setUp.

	resourceController := ActionsRESTfulController workingWith: rootSystem.
	resourceController serverUrl: self baseUrl asZnUrl.

]

{ #category : #running }
ActionsRESTfulControllerTest >> setUpRequirements [

	self flag: 'requireActionManagementSystem'.
	
	self
		registerSubsystem: (TimeSystem using: (FixedTimeSource on: self systemDateTime));
		registerSubsystem: MetadataSystem new;
		registerSubsystem: TimestampingSystem new;
		registerSubsystem: (IdentifierSystem using: self identifierProvider);
		registerSubsystem: ActionManagementSystem new
]

{ #category : #'private - accessing' }
ActionsRESTfulControllerTest >> systemDateTime [

	^ DateTime 
		date: October first , 2014 
		timeOfDay: TimeOfDay noon 
		zone: TimeZones buenosAires
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

	self assert: self actionManagementSystem actions isEmpty.
	self registerGetDNSZones.
	self deny: self actionManagementSystem actions isEmpty.

	resourceController
		deleteActionBasedOn: (self requestToDeleteActionIdentifiedBy: self getDNSZonesIdentifier)
		within: self httpRequestContext.

	self assert: self actionManagementSystem actions isEmpty
]

{ #category : #tests }
ActionsRESTfulControllerTest >> testGetAction [

	| response |

	self
		registerGetDNSZones;
		registerAddDNSZone.

	response := resourceController
		getActionBasedOn:
			(self
				requestToGetActionIdentifiedBy: self getDNSZonesIdentifier
				accepting: self applicationJsonVersion1dot0dot0MediaType)
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response status equals: 200;
		assert: response contentType equals: self applicationJsonVersion1dot0dot0MediaType;
		assert: response entityTag equals: '"2e7eccc8701bd15953f68d2dce8b8fa2d68575ee"' asETag;
		withJsonFromContentsIn: response contents
			do: [ :json | 
			self
				assert: json name equals: 'Get DNS zones';
				assert: json links self
					equals: 'https://tests.cosmos.com/actions/ab203809-4537-0d00-96a8-67bd07fa2cfc' ];
		assert: response contents equals: self getDNSZonesAsJSON
]

{ #category : #tests }
ActionsRESTfulControllerTest >> testGetActions [

	| response |

	self
		registerGetDNSZones;
		registerAddDNSZone.

	response := resourceController
		getActionsBasedOn: self requestToGetActions
		within: self httpRequestContext.

	self
		assert: response code equals: 200;
		assert: response contents
			equals:
			'[{"name":"Get DNS zones","http_request":{"request_line":{"method":"GET","url":"https://api.cloudflare.com/client/v4/zones/77527abc25e3d9004fd943209c925e4e/dns_records","version":"HTTP/1.1"},"headers":[{"key":"X-Auth-Email","value":"patchinko@gmail.com"},{"key":"X-Auth-Key","value":"93b0b7a99ad1fc123d0d2b6508849db7e64"}]},"links":{"self":"https://tests.cosmos.com/actions/ab203809-4537-0d00-96a8-67bd07fa2cfc"}},{"name":"Add DNS zone","http_request":{"request_line":{"method":"POST","url":"https://api.cloudflare.com/client/v4/zones/77527abc25e3d9004fd943209c925e4e/dns_records","version":"HTTP/1.1"},"headers":[{"key":"X-Auth-Email","value":"patchinko@gmail.com"},{"key":"X-Auth-Key","value":"93b0b7a99ad1fc123d0d2b6508849db7e64"}]},"links":{"self":"https://tests.cosmos.com/actions/c3e53a0a-4537-0d00-96a9-ad5f07fa2cfc"}}]'
]

{ #category : #'private - media types' }
ActionsRESTfulControllerTest >> textPlainMediaType [

	^ 'text/plain;charset=utf-8' asMediaType
]

{ #category : #'private - accessing' }
ActionsRESTfulControllerTest >> urlForResourceIdentifiedBy: anIdentifier [

	^ self resourceUrl / anIdentifier printString asZnUrl
]
