Extension { #name : #SystemBasedUserStoryTest }

{ #category : #'*Cosmos-Actions-Tests-SystemModel' }
SystemBasedUserStoryTest >> actionManagementSystem [

	^ rootSystem systemImplementing: #ActionManagementSystemInterface
]

{ #category : #'*Cosmos-Actions-Tests-SystemModel' }
SystemBasedUserStoryTest >> requireActionManagementSystem [

	self
		requireTimeSystem;
		requireEventNotificationSystem.
	systemBuilder add: ActionManagementSystem new
]
