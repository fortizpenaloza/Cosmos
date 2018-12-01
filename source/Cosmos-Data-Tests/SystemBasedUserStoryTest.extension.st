Extension { #name : #SystemBasedUserStoryTest }

{ #category : #'*Cosmos-Data-Tests' }
SystemBasedUserStoryTest >> dataManagementSystem [

	^ rootSystem systemImplementing: #DataStreamManagementSystemInterface
]

{ #category : #'*Cosmos-Data-Tests' }
SystemBasedUserStoryTest >> requireDataManagementSystem [

	self
		requireTimeSystem;
		requireEventNotificationSystem;
		requireMetadataSystem;
		requireIdentifierSystem.
	systemBuilder add: DataStreamManagementSystem new
]
