Extension { #name : #SystemBasedUserStoryTest }

{ #category : #'*Cosmos-Commands-Tests-SystemModel' }
SystemBasedUserStoryTest >> commandManagementSystem [

	^ rootSystem systemImplementing: #CommandManagementSystemInterface
]

{ #category : #'*Cosmos-Commands-Tests-SystemModel' }
SystemBasedUserStoryTest >> requireCommandManagementSystem [

	self requireTimeSystem.
	systemBuilder add: (CommandManagementSystem new)
]
