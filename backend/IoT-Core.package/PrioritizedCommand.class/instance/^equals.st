comparing
= anObject

	^ self == anObject
		or: [ (self class = anObject class)
				and: [ command = anObject command
						and: [ priority = anObject priority
								and: [ prioritizationDateTime = anObject prioritizationDateTime ] ] ] ]