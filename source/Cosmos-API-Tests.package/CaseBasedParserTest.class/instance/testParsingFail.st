tests
testParsingFail

	| parser |

	parser := CaseBasedParser new
		parsing: #high to: QueuePriority high;
		parsing: #medium to: QueuePriority medium;
		parsing: #low to: QueuePriority low;
		yourself.

	self should: [ parser parse: 'lower' ] raise: ParsingFailed withDescription: '"lower" is not a valid object'