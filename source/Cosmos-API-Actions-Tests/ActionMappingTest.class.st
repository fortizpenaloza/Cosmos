Class {
	#name : #ActionMappingTest,
	#superclass : #TestCase,
	#category : 'Cosmos-API-Actions-Tests'
}

{ #category : #accessing }
ActionMappingTest >> action [

	^ Action
		named: 'List DNS records'
		createdOn: (September sixth , 2015) atNoon
		toEvaluate:
			(ZnRequest new
				requestLine:
					(ZnRequestLine empty
						method: #GET;
						uri: 'https://api.cloudflare.com/client/v4/zones/77527abc25e3d9004fd943209c925e4e/dns_records' asZnUrl;
						version: ZnConstants defaultHTTPVersion;
						yourself);
				headers: {
					'X-Auth-Email' -> 'patchinko@gmail.com'.  
					'X-Auth-Key' -> '93b0b7a99ad1fc123d0d2b6508849db7e64'};
				yourself)
]

{ #category : #accessing }
ActionMappingTest >> actionMapping [

	^ [ :action | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: Action
					do: [ :mapping | 
					mapping
						mapAccessor: #name;
						mapAccessor: #creationDateTime to: #created_on;
						mapInstVar: #evaluationPolicy to: #http_request];
				for: ZnRequest do: [ :mapping | 
					mapping
						mapAccessor: #requestLine to: #request_line;
						mapAccessor: #headers;
						mapAccessor: #entity ];
				for: ZnRequestLine do: [ :mapping | 
					mapping
						mapAccessor: #method;
						mapAccessor: #uri to: #URL;
						mapInstVar: #version ];
				for: ZnUrl customDo: [ :mapping |
					mapping
						encoder: [ :url | url printString ] ];
				for: ZnHeaders do: [ :mapping |
					mapping
						mapAccessor: #headers ];
				for: Association do: [ :mapping |
					mapping
						mapAccessor: #key;
						mapAccessor: #value ];
				for: DateTime customDo: [ :mapping | 
					mapping
						encoder: [ :dateTime | ISO8601DateTimeFormatter usingExtendedFormat format: dateTime ] ];
				prettyPrint: true;
				nextPut: action ] ]
]

{ #category : #tests }
ActionMappingTest >> testActionMapping [

	self
		assert: (self actionMapping value: self action)
		equals:
			('{
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
}' expandMacrosWith: TimeZones local offset)
]
