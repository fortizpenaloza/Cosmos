Class {
	#name : #HTTPHeadersDecoder,
	#superclass : #Object,
	#category : #'Cosmos-API-Actions'
}

{ #category : #decoding }
HTTPHeadersDecoder >> decode: rawHeaders [

	^ rawHeaders
		inject: ZnHeaders new
		into: [ :headers :rawHeader | 
			headers
				at: (rawHeader at: #key) put: (rawHeader at: #value);
				yourself ]
]
