Extension { #name : #DateTime }

{ #category : #'*Cosmos-API-Common' }
DateTime >> neoJsonOn: neoJSONWriter [

	neoJSONWriter writeString: ( ISO8601DateTimeFormatter usingExtendedFormat format: self )
]
