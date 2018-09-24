Class {
	#name : #HTTPRequestParser,
	#superclass : #Object,
	#category : 'Cosmos-API-Actions'
}

{ #category : #'private-parsing' }
HTTPRequestParser >> decode: aKey from: aDictionary with: aParser [

	^ self
		parse: aKey
		from: aDictionary
		with: aParser
		ifNotFound: [ Error signal: ('<s1> is mandatory and must be present' expandMacrosWith: aKey) ]
]

{ #category : #'private-parsers' }
HTTPRequestParser >> headersParser [
	
	^ HTTPHeadersParser new
]

{ #category : #parsing }
HTTPRequestParser >> parse: aRawRequest [

	| requestLine headers |

	requestLine := self decode: #request_line from: aRawRequest with: self requestLineParser.
	headers := self decode: #headers from: aRawRequest with: self headersParser.

	^ ZnRequest empty
		requestLine: requestLine;
		headers: headers;
		yourself
]

{ #category : #'private-parsing' }
HTTPRequestParser >> parse: aKey from: aDictionary with: aParser ifNotFound: aNotFoundBlock [

	^ aDictionary
		at: aKey
		ifPresent: [ :rawData | aParser parse: rawData ]
		ifAbsent: aNotFoundBlock
]

{ #category : #'private-parsers' }
HTTPRequestParser >> requestLineParser [
	
	^ HTTPRequestLineParser new
]
