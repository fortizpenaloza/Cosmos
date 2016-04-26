tests
testInstanceCreationAndAccessing

	| dataChannel identifier name creationDateTime |

	identifier := 1.
	name := 'Channel #1'.
	creationDateTime := (September sixth , 2015) atNoon.

	dataChannel := DataChannel identifiedBy: identifier named: name createdOn: creationDateTime.

	self
		assert: dataChannel identifier equals: identifier;
		assert: dataChannel name equals: name;
		assert: dataChannel creationDateTime equals: creationDateTime