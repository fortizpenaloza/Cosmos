subsystem management
register: aSubsystem

	systems add: aSubsystem.
	aSubsystem parent: self.
	^ aSubsystem