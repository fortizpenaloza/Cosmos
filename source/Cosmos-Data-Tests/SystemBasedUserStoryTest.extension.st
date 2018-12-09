Extension { #name : #SystemBasedUserStoryTest }

{ #category : #'*Cosmos-Data-Tests' }
SystemBasedUserStoryTest >> dataManagementSystem [

	^ rootSystem systemImplementing: #DataStreamManagementSystemInterface
]
