private-parsers
actionParser

	^ BlockToParserAdapter
		onParsingEvaluate: [ :string | 
			self actionManagementSystem
				actionNamed: string
				ifFound: [ :action | action ]
				ifNone: [ Error signal: 'Action not found' ] ]