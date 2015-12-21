test
testCreation

	| feed identifier name description creationDateTime |

	identifier := 1.
	name := 'Feed'.
	description := 'Feed description'.
	creationDateTime := (September eleventh , 2014) atNoon.

	feed := Feed
		identifiedBy: identifier
		named: name
		describedAs: description
		createdOn: creationDateTime.

	self assert: feed identifier equals: identifier.
	self assert: feed name equals: name.
	self assert: feed description equals: description.
	self assert: feed creationDateTime equals: creationDateTime.
	self assert: feed dataStreams isEmpty