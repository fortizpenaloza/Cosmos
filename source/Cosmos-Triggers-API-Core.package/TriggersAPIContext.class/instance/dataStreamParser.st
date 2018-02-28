private-parsers
dataStreamParser

	^ BlockToParserAdapter
		onParsingEvaluate: [ :string | 
			self dataManagementSystem
				streamNamed: string
				ifFound: [ :stream | stream ]
				ifNone: [ Error signal: 'aca loco' ] ]