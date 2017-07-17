*Cosmos-Actions-Tests-SystemModel
requireActionManagementSystem

	self
		requireTimeSystem;
		requireEventNotificationSystem.
	systemBuilder add: ActionManagementSystem new