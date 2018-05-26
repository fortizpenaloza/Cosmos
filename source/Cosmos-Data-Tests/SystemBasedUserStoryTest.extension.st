Extension { #name : #SystemBasedUserStoryTest }

{ #category : #'*Cosmos-Data-Tests-SystemModel' }
SystemBasedUserStoryTest >> dataManagementSystem [

	^ rootSystem systemImplementing: #DataManagementSystemInterface
]

{ #category : #'*Cosmos-Data-Tests-SystemModel' }
SystemBasedUserStoryTest >> requireDataManagementSystem [

	self requireTimeSystem.
	self requireEventNotificationSystem.
	systemBuilder add: (DataManagementSystem new)
]
