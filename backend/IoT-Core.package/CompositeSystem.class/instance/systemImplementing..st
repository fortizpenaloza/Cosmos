subsystem lookup
systemImplementing: aSystemInterface

	^ self
		systemImplementing: aSystemInterface
		ifNone: [ InterfaceImplementationNotFound signalFor: aSystemInterface ]