Extension { #name : #SystemBasedUserStoryTest }

{ #category : #'*Cosmos-Metadata-Tests' }
SystemBasedUserStoryTest >> metadataSystem [

	^ rootSystem systemImplementing: #MetadataSystemInterface
]
