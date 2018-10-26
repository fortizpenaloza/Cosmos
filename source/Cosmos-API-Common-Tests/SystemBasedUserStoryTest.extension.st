Extension { #name : #SystemBasedUserStoryTest }

{ #category : #'*Cosmos-API-Common-Tests' }
SystemBasedUserStoryTest >> withJsonFromContentsIn: httpResponse do: aBlock [

	aBlock value: (NeoJSONObject fromString: httpResponse contents)
]
