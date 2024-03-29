Class {
	#name : #ActionsRESTfulControllerTest,
	#superclass : #SystemBasedRESTfulControllerUserStoryTest,
	#category : #'Cosmos-API-Actions-Tests'
}

{ #category : #'private - media types' }
ActionsRESTfulControllerTest >> actionVersion1dot0dot0MediaType [

	^ resourceController actionVersion1dot0dot0MediaType 
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
				entity: (ZnEntity json: '{"isEnabled":true}');
				yourself).

	self actionManagementSystem register: action
]

{ #category : #'test support' }
ActionsRESTfulControllerTest >> registerGetDNSZones [

	| action |

	action := Action
		named: 'Get DNS zones'
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
				yourself).

	self actionManagementSystem register: action
]

{ #category : #'private - requests' }
ActionsRESTfulControllerTest >> requestToCreateActionFrom: aJSON [

	^ self requestToPost: aJSON as: self actionVersion1dot0dot0MediaType
]

{ #category : #'private - requests' }
ActionsRESTfulControllerTest >> requestToDeleteActionIdentifiedBy: anIdentifier [ 

	^ TeaRequest
		fromZnRequest: (self urlForResourceIdentifiedBy: anIdentifier)
		pathParams: {(#identifier -> anIdentifier)} asDictionary
]

{ #category : #'private - requests' }
ActionsRESTfulControllerTest >> requestToGetActionIdentifiedBy: anIdentifier accepting: aMediaType [

	^ self requestToGetResourceIdentifiedBy: anIdentifier accepting: aMediaType
]

{ #category : #'private - requests' }
ActionsRESTfulControllerTest >> requestToGetActions [

	^ self requestToGetResourcesAccepting: self actionVersion1dot0dot0MediaType
]

{ #category : #running }
ActionsRESTfulControllerTest >> setUpRequirements [

	self flag: 'requireActionManagementSystem'.
	
	self
		registerSubsystem: (TimeSystem using: (FixedTimeSource on: self systemDateTime));
		registerSubsystem: EventNotificationSystem new;
		registerSubsystem: MetadataSystem new;
		registerSubsystem: TimestampingSystem new;
		registerSubsystem: (IdentifierSystem using: self identifierProvider);
		registerSubsystem: ActionManagementSystem new
]

{ #category : #running }
ActionsRESTfulControllerTest >> setUpResourceController [

	resourceController := ActionsRESTfulController workingWith: rootSystem.
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

	| response json |

	self assert: self actionManagementSystem actions isEmpty.
	
	json := '{"name":"OpenSprinkler","http_request":{"request_line":{"url":"http://localhost:8090/commands","method":"POST","version":"HTTP/1.1"},"headers":[{"key":"content-type","value":"application/json"}],"body":"{\"command\":\"Open Sprinkler\",\"priority\":30}"}}'.

	response := resourceController
		createActionBasedOn: (self requestToCreateActionFrom: json)
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 201;
		assert: response location
			equals:
			'https://tests.cosmos.com/actions/ab203809-4537-0d00-96a8-67bd07fa2cfc';
		assert: response contentType equals: self actionVersion1dot0dot0MediaType.

	self
		withTheOnlyOneIn: self actionManagementSystem actions
		do: [ :action | self assert: action name equals: 'OpenSprinkler' ]
]

{ #category : #tests }
ActionsRESTfulControllerTest >> testCreateActionWithoutEntity [

	| response json |

	self assert: self actionManagementSystem actions isEmpty.

	json := '{"name":"Get commands","http_request":{"request_line":{"url":"http://localhost:8090/commands","method":"GET","version":"HTTP/1.1"},"headers":[{"key":"accept","value":"application/json"}]}}'.

	response := resourceController
		createActionBasedOn: ( self requestToCreateActionFrom: json )
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 201;
		assert: response location
			equals: 'https://tests.cosmos.com/actions/ab203809-4537-0d00-96a8-67bd07fa2cfc';
		assert: response contentType equals: self actionVersion1dot0dot0MediaType.

	self
		withTheOnlyOneIn: self actionManagementSystem actions
		do: [ :action | self assert: action name equals: 'Get commands' ]
]

{ #category : #tests }
ActionsRESTfulControllerTest >> testCreateActionWithoutHeaders [

	| response json |

	self assert: self actionManagementSystem actions isEmpty.
	
	json := '{"name":"OpenSprinkler","http_request":{"request_line":{"url":"http://localhost:8090/commands","method":"POST","version":"HTTP/1.1"},"body":"{\"command\":\"Open Sprinkler\",\"priority\":30}"}}'.

	response := resourceController
		createActionBasedOn: (self requestToCreateActionFrom: json)
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 201;
		assert: response location
			equals:
			'https://tests.cosmos.com/actions/ab203809-4537-0d00-96a8-67bd07fa2cfc';
		assert: response contentType equals: self actionVersion1dot0dot0MediaType.

	self
		withTheOnlyOneIn: self actionManagementSystem actions
		do: [ :action | self assert: action name equals: 'OpenSprinkler' ]
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
				accepting: self actionVersion1dot0dot0MediaType)
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response status equals: 200;
		assert: response contentType
			equals: self actionVersion1dot0dot0MediaType;
		assert: response entityTag
			equals: '"157f5e37dd384bad597fad6d9b1df6e4bac6f3bc"' asETag;
		withJSONFromContentsIn: response contents
			do: [ :json | 
			self
				assert: json name equals: 'Get DNS zones';
				assert: json links self
					equals:
					'https://tests.cosmos.com/actions/ab203809-4537-0d00-96a8-67bd07fa2cfc' ];
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
			'{"items":[{"name":"Get DNS zones","http_request":{"request_line":{"method":"GET","url":"https://api.cloudflare.com/client/v4/zones/77527abc25e3d9004fd943209c925e4e/dns_records","version":"HTTP/1.1"},"headers":[{"key":"X-Auth-Email","value":"patchinko@gmail.com"},{"key":"X-Auth-Key","value":"93b0b7a99ad1fc123d0d2b6508849db7e64"}]},"links":{"self":"https://tests.cosmos.com/actions/ab203809-4537-0d00-96a8-67bd07fa2cfc"}},{"name":"Add DNS zone","http_request":{"request_line":{"method":"POST","url":"https://api.cloudflare.com/client/v4/zones/77527abc25e3d9004fd943209c925e4e/dns_records","version":"HTTP/1.1"},"headers":[{"key":"X-Auth-Email","value":"patchinko@gmail.com"},{"key":"X-Auth-Key","value":"93b0b7a99ad1fc123d0d2b6508849db7e64"},{"key":"Content-Type","value":"application/json"},{"key":"Content-Length","value":"18"}],"entity":{"contentType":"application/json","contents":"{\"isEnabled\":true}"}},"links":{"self":"https://tests.cosmos.com/actions/c3e53a0a-4537-0d00-96a9-ad5f07fa2cfc"}}],"links":{"self":"https://tests.cosmos.com/actions"}}'
]
