Extension { #name : #ZnStringEntity }

{ #category : #'*Cosmos-API' }
ZnStringEntity class >> json: string [

	^ (self type: ZnMimeType applicationJson)
		string: string;
		yourself
]
