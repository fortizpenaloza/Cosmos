parsing
parseActionFrom: aJSON

	^ self
		parse: #action
		from: aJSON
		with: self actionParser
		ifNotFound: [ self halt ]