API
deregisterNamed: aName

	| name |

	name := aName replaceAll: $_ with: Character space.

	self triggerManagementSystem deregisterNamed: name.

	^ ZnResponse noContent