instance creation
identifiedBy: anIdentifier named: aName describedAs: aDescription createdOn: aDateTime

	^ self new
		initializeIdentifiedBy: anIdentifier
		named: aName
		describedAs: aDescription
		createdOn: aDateTime