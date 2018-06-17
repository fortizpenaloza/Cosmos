Extension { #name : #ZnEntity }

{ #category : #'*Cosmos-API' }
ZnEntity class >> json: json [

	^ self stringEntityClass json: json
]
