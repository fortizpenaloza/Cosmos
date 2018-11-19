Class {
	#name : #HTTPRequestDecoder,
	#superclass : #Object,
	#category : #'Cosmos-API-Actions'
}

{ #category : #decoding }
HTTPRequestDecoder >> decode: aRawRequest [

	| requestLine headers |

	requestLine := self decode: #request_line from: aRawRequest with: self requestLineDecoder.
	headers := self decode: #headers from: aRawRequest with: self headersDecoder.

	^ ZnRequest empty
		requestLine: requestLine;
		headers: headers;
		yourself
]

{ #category : #'private - decoding' }
HTTPRequestDecoder >> decode: aKey from: aDictionary using: aDecoder ifAbsent: aBlock [

	^ aDictionary
		at: aKey
		ifPresent: [ :rawData | aDecoder decode: rawData ]
		ifAbsent: aBlock
]

{ #category : #'private - decoding' }
HTTPRequestDecoder >> decode: aKey from: aDictionary with: aDecoder [

	^ self
		decode: aKey
		from: aDictionary
		using: aDecoder
		ifAbsent: [ Error signal: ('<s1> is mandatory and must be present' expandMacrosWith: aKey) ]
]

{ #category : #'private - decoders' }
HTTPRequestDecoder >> headersDecoder [
	
	^ HTTPHeadersDecoder new
]

{ #category : #'private - decoders' }
HTTPRequestDecoder >> requestLineDecoder [
	
	^ HTTPRequestLineDecoder new
]
