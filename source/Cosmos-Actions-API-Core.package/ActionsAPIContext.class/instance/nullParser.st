private-parsers
nullParser
	
	^ BlockToParserAdapter onParsingEvaluate: [ :string | string ] 