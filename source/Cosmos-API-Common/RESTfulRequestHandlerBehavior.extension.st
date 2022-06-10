Extension { #name : #RESTfulRequestHandlerBehavior }

{ #category : #'*Cosmos-API-Common' }
RESTfulRequestHandlerBehavior >> entityTagOf: resource encodedAs: mediaType within: requestContext [

	^ EntityTag with: ( entityTagCalculator value: resource value: mediaType value: requestContext value: self )
]

{ #category : #'*Cosmos-API-Common' }
RESTfulRequestHandlerBehavior >> ifNoneMatchHeaderPresentIn: httpRequest do: aMonadycBlock [

	httpRequest headers
		at: #'If-None-Match'
		ifPresent: [ :ifNoneMatchHeader | aMonadycBlock value: ifNoneMatchHeader asEntityTag ]
]
