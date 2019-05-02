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
	headers hasContentType
		ifTrue: [ entity := self entityFrom: aRawRequest ofType: headers contentType ]
		ifFalse:
			[ entity := self entityFrom: aRawRequest ofType: ZnMimeType textPlain ].


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
HTTPRequestDecoder >> entityDecoderOfType: aMediaType [

	^ [ :rawEntity | ZnEntity with: rawEntity type: aMediaType ]
]

{ #category : #decoding }
HTTPRequestDecoder >> entityFrom: aRawRequest ofType: aMediaType [

	^ self
		decode: #body
		from: aRawRequest
		using: (self entityDecoderOfType: aMediaType)
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
		uri: (self urlFrom: rawRequestLine);
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

{ #category : #'private - decoders' }
HTTPRequestDecoder >> urlFrom: rawRequestLine [

	| url |

	url := (rawRequestLine at: #url) asZnUrl.

	AssertionChecker
		enforce: [ url hasHost ]
		because: [ 'The provided url must have a host' ]
		raising: InstanceCreationFailed.

	^ url
]
