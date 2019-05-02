"
A HTTPRequestDecoderTest is a test class for testing the behavior of HTTPRequestDecoder
"
Class {
	#name : #HTTPRequestDecoderTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Actions-Tests'
}

{ #category : #tests }
HTTPRequestDecoderTest >> testDecoding [

	| json rawAction httpRequest |

	json := '{"name":"OpenSprinkler","http_request":{"request_line":{"url":"http://localhost:8090/commands","method":"POST","version":"HTTP/1.1"},"headers":[],"body":"{\"command\":\"Open Sprinkler\",\"priority\":30}"}}'.

	rawAction := NeoJSONObject fromString: json.

	httpRequest := HTTPRequestDecoder new
		decode: (rawAction at: #http_request).

	self
		assert: httpRequest method equals: #POST;
		assert: httpRequest url
			equals: 'http://localhost:8090/commands' asUrl;
		assert: httpRequest headers contentType equals: ZnMimeType textPlain;
		assert: httpRequest headers contentLength equals: 42;
		assert: httpRequest contents equals: '{"command":"Open Sprinkler","priority":30}'
]

{ #category : #tests }
HTTPRequestDecoderTest >> testDecodingFailsIfUrlNotProvided [

	| json rawAction |

	json := '{"name":"Action1","http_request":{"request_line":{"url":"/commands","method":"POST","version":"HTTP/1.1"},"headers":[],"body":"{\"foo\":\"bar\", \"jane\":\"doe\"}"}}'.

	rawAction := NeoJSONObject fromString: json.

	self
		should: [ HTTPRequestDecoder new decode: (rawAction at: #http_request) ]
		raise: InstanceCreationFailed
		withMessageText: 'The provided url must have a host'
]

{ #category : #tests }
HTTPRequestDecoderTest >> testDecodingWithHeader [

	| json rawAction httpRequest |

	json := '{"name":"OpenSprinkler","http_request":{"request_line":{"url":"http://localhost:8090/commands","method":"POST","version":"HTTP/1.1"},"headers":[{"key":"content-type","value":"application/json"}],"body":"{\"command\":\"Open Sprinkler\",\"priority\":30}"}}'.

	rawAction := NeoJSONObject fromString: json.

	httpRequest := HTTPRequestDecoder new
		decode: (rawAction at: #http_request).

	self
		assert: httpRequest method equals: #POST;
		assert: httpRequest url
			equals: 'http://localhost:8090/commands' asUrl;
		assert: httpRequest headers contentType equals: ZnMimeType applicationJson;
		assert: httpRequest headers contentLength equals: 42;
		assert: httpRequest contents equals: '{"command":"Open Sprinkler","priority":30}'
]
