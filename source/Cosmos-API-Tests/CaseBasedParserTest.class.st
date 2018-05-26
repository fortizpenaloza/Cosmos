Class {
	#name : #CaseBasedParserTest,
	#superclass : #TestCase,
	#category : 'Cosmos-API-Tests-Parsing'
}

{ #category : #tests }
CaseBasedParserTest >> testParsing [

	| parser |
	
	parser := CaseBasedParser new
		parsing: #high to: QueuePriority high;
		parsing: #medium to: QueuePriority medium;
		parsing: #low to: QueuePriority low;
		yourself.

	self
		assert: (parser parse: 'high') equals: QueuePriority high;
		assert: (parser parse: 'medium') equals: QueuePriority medium;
		assert: (parser parse: 'low') equals: QueuePriority low
]

{ #category : #tests }
CaseBasedParserTest >> testParsingFail [

	| parser |

	parser := CaseBasedParser new
		parsing: #high to: QueuePriority high;
		parsing: #medium to: QueuePriority medium;
		parsing: #low to: QueuePriority low;
		yourself.

	self should: [ parser parse: 'lower' ] raise: ParsingFailed withDescription: '"lower" is not a valid object'
]
