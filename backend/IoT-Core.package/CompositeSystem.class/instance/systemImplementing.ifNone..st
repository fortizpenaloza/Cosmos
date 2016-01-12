subsystem lookup
systemImplementing: aSystemInterface ifNone: anExceptionalBlock

	^ self
		systemImplementing: aSystemInterface
		ifFound: [ :implementor | implementor ]
		ifNone: anExceptionalBlock