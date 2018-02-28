API
deregisterNamed: aName

	|name | 
	
	name := aName replaceAll: $_ with: Character space.
	
	self actionManagementSystem deregisterNamed: name.

	^ ZnResponse noContent