private-parsers
timeIntervalParser

	^ BlockToParserAdapter onParsingEvaluate: [:string |  TimeUnits minute with: 5 ]