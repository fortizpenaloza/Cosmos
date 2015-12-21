initialize-release
initializeIdentifiedBy: anIdentifier named: aName describedAs: aDescription createdOn: aDateTime

	identifier := anIdentifier.
	name := aName.
	description := aDescription.
	dateTime := aDateTime.
	dataStreams := OrderedCollection new