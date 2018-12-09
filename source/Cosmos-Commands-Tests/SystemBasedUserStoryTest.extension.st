Extension { #name : #SystemBasedUserStoryTest }

{ #category : #'*Cosmos-Commands-Tests-SystemModel' }
SystemBasedUserStoryTest >> commandManagementSystem [

	^ rootSystem systemImplementing: #CommandManagementSystemInterface
]
