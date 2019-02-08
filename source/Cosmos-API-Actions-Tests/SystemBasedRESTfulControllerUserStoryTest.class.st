Class {
	#name : #SystemBasedRESTfulControllerUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'resourceController'
	],
	#category : #'Cosmos-API-Actions-Tests'
}

{ #category : #'private - support' }
SystemBasedRESTfulControllerUserStoryTest >> assertUrl: aStringOrUrl equals: anotherStringOrUrl [

	self assert: aStringOrUrl asZnUrl equals: anotherStringOrUrl asZnUrl
]

{ #category : #'private - accessing' }
SystemBasedRESTfulControllerUserStoryTest >> baseUrl [

	^ self subclassResponsibility
]

{ #category : #'private - accessing' }
SystemBasedRESTfulControllerUserStoryTest >> httpRequestContext [

	^ HttpRequestContext new
]

{ #category : #'private - requests support' }
SystemBasedRESTfulControllerUserStoryTest >> requestToGet: aUrl accepting: aMediaType [

	^ TeaRequest
		fromZnRequest:
			((ZnRequest get: aUrl)
				setAccept: aMediaType;
				yourself)
]

{ #category : #'private - requests support' }
SystemBasedRESTfulControllerUserStoryTest >> requestToGetResourceIdentifiedBy: anIdentifier accepting: aMediaType [

	^ TeaRequest
		fromZnRequest:
			((ZnRequest get: (self urlForResourceIdentifiedBy: anIdentifier))
				setAccept: aMediaType;
				yourself)
		pathParams: {(#identifier -> anIdentifier)} asDictionary
]

{ #category : #'private - requests support' }
SystemBasedRESTfulControllerUserStoryTest >> requestToGetResourcesAccepting: aMediaType [

	^ self requestToGet: self resourceUrl accepting: aMediaType
]

{ #category : #'private - requests support' }
SystemBasedRESTfulControllerUserStoryTest >> requestToPost: aRepresentation as: aMediaType [ 

	^ TeaRequest
		fromZnRequest:
			((ZnRequest post: self resourceUrl)
				entity: (ZnEntity with: aRepresentation type: aMediaType);
				yourself)
]

{ #category : #'private - accessing' }
SystemBasedRESTfulControllerUserStoryTest >> resourceUrl [

	^ self baseUrl / resourceController specification endpoint
	

]

{ #category : #running }
SystemBasedRESTfulControllerUserStoryTest >> setUp [

	super setUp.
	self setUpResourceController.

	resourceController serverUrl: self baseUrl asZnUrl
]

{ #category : #running }
SystemBasedRESTfulControllerUserStoryTest >> setUpResourceController [

	self subclassResponsibility
]

{ #category : #'private - accessing' }
SystemBasedRESTfulControllerUserStoryTest >> urlForResourceIdentifiedBy: anIdentifier [

	^ self resourceUrl / anIdentifier printString asZnUrl
]

{ #category : #'private - support' }
SystemBasedRESTfulControllerUserStoryTest >> withJsonFromContentsIn: httpResponse do: aBlock [

	aBlock value: (NeoJSONObject fromString: httpResponse contents)
]
