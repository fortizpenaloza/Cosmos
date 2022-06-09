Extension { #name : #RESTfulRequestHandlerBehavior }

{ #category : #'*Cosmos-API-Common' }
RESTfulRequestHandlerBehavior >> entityTagOf: resource encodedAs: mediaType within: requestContext [

	^ EntityTag with: ( entityTagCalculator value: resource value: mediaType value: requestContext value: self )
]
