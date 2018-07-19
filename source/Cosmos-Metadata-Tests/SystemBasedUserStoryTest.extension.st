Extension { #name : #SystemBasedUserStoryTest }

{ #category : #'*Cosmos-Metadata-Tests' }
SystemBasedUserStoryTest >> metadataSystem [

	^ rootSystem systemImplementing: #MetadataSystemInterface
]

{ #category : #'*Cosmos-Metadata-Tests' }
SystemBasedUserStoryTest >> requireMetadataSystem [
	
	systemBuilder add: MetadataSystem new
]
