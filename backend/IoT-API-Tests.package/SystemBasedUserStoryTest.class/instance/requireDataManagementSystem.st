configuring
requireDataManagementSystem

	systemBuilder 
		add: EventNotificationSystem new;
		add: (DataManagementSystem using: identifierProvider)