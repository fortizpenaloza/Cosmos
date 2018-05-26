Extension { #name : #ZnStringEntity }

{ #category : #'*Cosmos-API-Core' }
ZnStringEntity class >> json: string [

	^ (self type: ZnMimeType applicationJson)
		string: string;
		yourself
]
