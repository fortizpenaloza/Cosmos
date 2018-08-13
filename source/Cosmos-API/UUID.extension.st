Extension { #name : #UUID }

{ #category : #'*Cosmos-API' }
UUID >> neoJsonOn: neoJSONWriter [

	neoJSONWriter writeString: self asString36
]
