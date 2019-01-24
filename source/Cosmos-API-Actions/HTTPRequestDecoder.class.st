Class {
	#name : #HTTPRequestDecoder,
	#superclass : #Object,
	#category : #'Cosmos-API-Actions'
}

{ #category : #decoding }
HTTPRequestDecoder >> decode: aRawRequest [

	| requestLine headers |

	requestLine := self requestLineFrom: aRawRequest.
	headers := self headersFrom: aRawRequest.

	^ ZnRequest empty
		requestLine: requestLine;
		headers: headers;
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
HTTPRequestDecoder >> headersDecoder [
	
	^ HTTPHeadersDecoder new
]

{ #category : #decoding }
HTTPRequestDecoder >> headersFrom: aRawRequest [

	^ self decode: #headers from: aRawRequest using: self headersDecoder
]

{ #category : #'private - decoders' }
HTTPRequestDecoder >> requestLineDecoder [
	
	^ HTTPRequestLineDecoder new
]

{ #category : #decoding }
HTTPRequestDecoder >> requestLineFrom: aRawRequest [

	^ self
		decode: #request_line
		from: aRawRequest
		using: self requestLineDecoder
]
