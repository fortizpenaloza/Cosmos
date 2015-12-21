initialize-release
initializeSubsystemOf: aParentSystem using: aTimeSource

	aParentSystem register: self as: #timeSystem.
	timeSource := aTimeSource