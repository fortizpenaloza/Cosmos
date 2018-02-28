parsing
parseTimeIntervalFrom: aJSON

	^ self
		parse: #time_interval
		from: aJSON
		with: self timeIntervalParser
		ifNotFound: [ self halt ]