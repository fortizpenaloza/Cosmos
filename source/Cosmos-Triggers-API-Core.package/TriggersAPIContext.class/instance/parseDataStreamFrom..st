parsing
parseDataStreamFrom: aJSON

	^ self
		parse: #data_stream
		from: aJSON
		with: self dataStreamParser
		ifNotFound: [ self halt ]