as yet unclassified
= anObject

	^ self == anObject
		or: [ (self isKindOf: anObject class)
				and: [ command = anObject command
						and: [ priority = anObject priority
								and: [ prioritizationDateTime = anObject prioritizationDateTime ] ] ] ]