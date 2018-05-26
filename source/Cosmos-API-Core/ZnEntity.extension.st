Extension { #name : #ZnEntity }

{ #category : #'*Cosmos-API-Core' }
ZnEntity class >> json: json [

	^ self stringEntityClass json: json
]
