subsystem management
register: aSubsystem

	subsystems add: aSubsystem.
	aSubsystem parent: self.
	^ aSubsystem