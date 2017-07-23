signalling
signalConflic: aFailureExplanation

	^ self new
		tag: 409;
		signal: aFailureExplanation