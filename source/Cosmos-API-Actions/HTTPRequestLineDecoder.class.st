Class {
	#name : #HTTPRequestLineDecoder,
	#superclass : #Object,
	#category : #'Cosmos-API-Actions'
}

{ #category : #decoding }
HTTPRequestLineDecoder >> decode: rawRequestLine [

	^ ZnRequestLine empty
		method: (rawRequestLine at: #method);
		uri: (rawRequestLine at: #url) asZnUrl;
		version: (rawRequestLine at: #version);
		yourself
]
