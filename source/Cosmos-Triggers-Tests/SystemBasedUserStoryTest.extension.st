Extension { #name : #SystemBasedUserStoryTest }

{ #category : #'*Cosmos-Triggers-Tests-SystemModel' }
SystemBasedUserStoryTest >> triggerManagementSystem [

	^ rootSystem systemImplementing: #TriggerManagementSystemInterface
]
