Extension { #name : #SystemBasedUserStoryTest }

{ #category : #'*Cosmos-Triggers-Tests-SystemModel' }
SystemBasedUserStoryTest >> requireTriggerManagementSystem [

	self requireEventNotificationSystem.
	systemBuilder add: TriggerManagementSystem new
]

{ #category : #'*Cosmos-Triggers-Tests-SystemModel' }
SystemBasedUserStoryTest >> triggerManagementSystem [

	^ rootSystem systemImplementing: #TriggerManagementSystemInterface
]
