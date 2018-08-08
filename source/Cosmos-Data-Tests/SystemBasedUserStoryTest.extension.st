Extension { #name : #SystemBasedUserStoryTest }

{ #category : #'*Cosmos-Data-Tests' }
SystemBasedUserStoryTest >> dataManagementSystem [

	^ rootSystem systemImplementing: #DataManagementSystemInterface
]

{ #category : #'*Cosmos-Data-Tests' }
SystemBasedUserStoryTest >> requireDataManagementSystem [

	self requireTimeSystem.
	self requireEventNotificationSystem.
	self requireMetadataSystem.
	self requireIdentifierSystem.
	systemBuilder add: (DataManagementSystem new)
]
