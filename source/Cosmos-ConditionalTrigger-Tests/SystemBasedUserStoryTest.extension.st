Extension { #name : #SystemBasedUserStoryTest }

{ #category : #'*Cosmos-ConditionalTrigger-Tests-SystemModel' }
SystemBasedUserStoryTest >> requireTriggerManagementSystem [

	self requireEventNotificationSystem.
	systemBuilder add: TriggerManagementSystem new
]

{ #category : #'*Cosmos-ConditionalTrigger-Tests-SystemModel' }
SystemBasedUserStoryTest >> triggerManagementSystem [

	^ rootSystem systemImplementing: #TriggerManagementSystemInterface
]
