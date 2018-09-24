Extension { #name : #UUID }

{ #category : #'*Cosmos-API-Common' }
UUID >> neoJsonOn: neoJSONWriter [

	neoJSONWriter writeString: self asString36
]
