running
setUp

	| timeSource |

	timeSource := FixedTimeSource
		on: September tenth , 2015
		at: TimeOfDay noon.

	identifierProvider := FixedNumberProvider providing: 1.

	rootSystem := CompositeSystem
		of:
			(OrderedCollection new
				add: (TimeSystem using: timeSource);
				add: (CommandManagementSystem using: identifierProvider);
				yourself).

	rootSystem startUp