*IoT-Data-Tests-SystemModel
requireDataManagementSystem

	self requireTimeSystem.
	self requireEventNotificationSystem.
	systemBuilder add: (DataManagementSystem using: identifierProvider)