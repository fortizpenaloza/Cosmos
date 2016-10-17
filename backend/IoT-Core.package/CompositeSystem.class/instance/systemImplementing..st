subsystem lookup
systemImplementing: aSystemInterface

	^ self
		systemImplementing: aSystemInterface
		ifNone: [ SystemImplementationNotFound signalFor: aSystemInterface ]