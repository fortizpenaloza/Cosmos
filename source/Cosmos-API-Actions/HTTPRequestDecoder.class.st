Class {
	#name : #HTTPRequestDecoder,
	#superclass : #Object,
	#category : #'Cosmos-API-Actions'
}

{ #category : #decoding }
HTTPRequestDecoder >> decode: aRawRequest [

	| requestLine headers entity |

	requestLine := self requestLineFrom: aRawRequest.
	headers := self headersFrom: aRawRequest.
	entity := self entityFrom: aRawRequest.

	^ ZnRequest empty
		requestLine: requestLine;
		headers: headers;
		entity: entity;
		yourself
]

{ #category : #'private - decoding' }
HTTPRequestDecoder >> decode: aKey from: aDictionary using: aDecoder [

	^ self
		decode: aKey
		from: aDictionary
		using: aDecoder
		ifAbsent: [ KeyNotFound signal: ('<1s> is mandatory and must be present' expandMacrosWith: aKey) ]
]

{ #category : #'private - decoding' }
HTTPRequestDecoder >> decode: aKey from: aDictionary using: aDecoder ifAbsent: aBlock [

	^ aDictionary
		at: aKey
		ifPresent: [ :rawData | aDecoder decode: rawData ]
		ifAbsent: aBlock
]

{ #category : #'private - decoders' }
HTTPRequestDecoder >> entityDecoder [

	^ [ :rawEntity | 
	ZnStringEntity
		with: (rawEntity at: #contents)
		ofType: (rawEntity at: #contentType) asMediaType ]
]

{ #category : #decoding }
HTTPRequestDecoder >> entityFrom: aRawRequest [

	^ self
		decode: #entity
		from: aRawRequest
		using: self entityDecoder
		ifAbsent: ZnEntity new
]

{ #category : #'private - decoders' }
HTTPRequestDecoder >> headersDecoder [

	^ [ :rawHeaders | 
	rawHeaders
		inject: ZnHeaders new
		into: [ :headers :rawHeader | 
			headers
				at: (rawHeader at: #key) put: (rawHeader at: #value);
				yourself ] ]
]

{ #category : #decoding }
HTTPRequestDecoder >> headersFrom: aRawRequest [

	^ self
		decode: #headers
		from: aRawRequest
		using: self headersDecoder
		ifAbsent: ZnHeaders new
]

{ #category : #'private - decoders' }
HTTPRequestDecoder >> requestLineDecoder [

	^ [ :rawRequestLine | 
	ZnRequestLine empty
		method: (rawRequestLine at: #method);
		uri: (rawRequestLine at: #url) asZnUrl;
		version: (rawRequestLine at: #version);
		yourself ]
]

{ #category : #decoding }
HTTPRequestDecoder >> requestLineFrom: aRawRequest [

	^ self
		decode: #request_line
		from: aRawRequest
		using: self requestLineDecoder
]
