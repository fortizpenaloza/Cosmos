Class {
	#name : #HTTPRequestLineParser,
	#superclass : #Object,
	#category : 'Cosmos-Actions-API-Core-Parsing'
}

{ #category : #parsing }
HTTPRequestLineParser >> parse: rawRequestLine [

	^ ZnRequestLine empty
		method: (rawRequestLine at: #method);
		uri: (rawRequestLine at: #URL) asZnUrl;
		version: (rawRequestLine at: #version);
		yourself 
]
