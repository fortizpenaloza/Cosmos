signalling
signalConflict: aFailureExplanation

	^self signal: 409 describedBy: aFailureExplanation