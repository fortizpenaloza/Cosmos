signaling
signalBadRequest: aFailureExplanation

	^ self signal: 400 describedBy: aFailureExplanation