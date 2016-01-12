subsystem lookup
systemImplementing: aSystemInterface ifFound: aFoundBlock ifNone: anExceptionalBlock

	^ subsystems
		detect: [ :subsystem | subsystem implements: aSystemInterface ]
		ifFound: aFoundBlock
		ifNone: anExceptionalBlock