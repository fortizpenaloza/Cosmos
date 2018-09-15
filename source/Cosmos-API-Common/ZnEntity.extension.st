Extension { #name : #ZnEntity }

{ #category : #'*Cosmos-API-Common' }
ZnEntity class >> json: json [

	^ self stringEntityClass json: json
]
