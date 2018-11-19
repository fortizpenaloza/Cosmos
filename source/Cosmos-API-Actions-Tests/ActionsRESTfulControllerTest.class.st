Class {
	#name : #ActionsRESTfulControllerTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'controller'
	],
	#category : #'Cosmos-API-Actions-Tests'
}

{ #category : #accessing }
ActionsRESTfulControllerTest >> applicationJsonVersion1dot0dot0MediaType [

	^ 'application/json;version=1.0.0' asMediaType 
]

{ #category : #accessing }
ActionsRESTfulControllerTest >> dateTimeFormattedAsISO8601 [

	^ ISO8601DateTimeFormatter usingExtendedFormat
		format: self systemDateTime
]

{ #category : #accessing }
ActionsRESTfulControllerTest >> getActionsHttpRequest [

	^ (ZnRequest get: 'http://COSMOS_URL/v1/actions')
		setAccept: self applicationJsonVersion1dot0dot0MediaType
]

{ #category : #accessing }
ActionsRESTfulControllerTest >> httpRequestContext [

	^ HttpRequestContext new
]

{ #category : #running }
ActionsRESTfulControllerTest >> setUp [

	super setUp.

	controller := ActionsRESTfulController workingWith: rootSystem
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

	response := controller
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
		assert: response code equals: 201;
		assert: (response headers includesKey: 'Location').

	self
		withTheOnlyOneIn: self actionManagementSystem actions
		do:
			[ :action | self assert: action name equals: 'List DNS records' ]
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

	controller
		deleteActionBasedOn:
			(TeaRequest
				fromZnRequest: (ZnRequest delete: 'List_DNS_Records')
				pathParams: {(#name -> 'List_DNS_Records')} asDictionary )
		within: self httpRequestContext.

	self assert: self actionManagementSystem actions isEmpty
]

{ #category : #tests }
ActionsRESTfulControllerTest >> testGetActions [

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
									('X-Auth-Key' -> '93b0b7a99ad1fc123d0d2b6508849db7e64')}
										asDictionary);
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
									('X-Auth-Key' -> '93b0b7a99ad1fc123d0d2b6508849db7e64')}
										asDictionary);
						yourself)).

	response := controller
		getActionsBasedOn: self getActionsHttpRequest
		within: self httpRequestContext.

	self
		assert: response code equals: 200;
		assert: response contents
			equals:
			('[{"name":"Get DNS zones","http_request":{"request_line":{"method":"GET","url":"https://api.cloudflare.com/client/v4/zones/77527abc25e3d9004fd943209c925e4e/dns_records","version":"HTTP/1.1"},"headers":[{"key":"X-Auth-Email","value":"patchinko@gmail.com"},{"key":"X-Auth-Key","value":"93b0b7a99ad1fc123d0d2b6508849db7e64"}]}}]'
				expandMacrosWith: self dateTimeFormattedAsISO8601)
]
