initialize-release
initializeIdentifiedBy: anIdentifier createdOn: aDateTime 
	
	identifier := anIdentifier.
	creationDateTime := aDateTime.
	
	prioritizedCommands := OrderedCollection new.
	priorityQueue := PriorityQueue empty.	
	