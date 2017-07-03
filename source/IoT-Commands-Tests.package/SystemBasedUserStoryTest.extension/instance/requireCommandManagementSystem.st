*IoT-Commands-Tests-SystemModel
requireCommandManagementSystem

	self requireTimeSystem.
	systemBuilder add: (CommandManagementSystem using: identifierProvider)