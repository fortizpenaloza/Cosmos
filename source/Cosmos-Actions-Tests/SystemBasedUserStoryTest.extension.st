Extension { #name : #SystemBasedUserStoryTest }

{ #category : #'*Cosmos-Actions-Tests-SystemModel' }
SystemBasedUserStoryTest >> actionManagementSystem [

	^ rootSystem systemImplementing: #ActionManagementSystemInterface
]
