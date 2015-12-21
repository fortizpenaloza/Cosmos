initialize-release
initializeSubsystemOf: aParentSystem

	aParentSystem register: self as: #feedSystem.
	parentSystem := aParentSystem.
	
	numbering := 	SequentialNumberProvider new.
	feeds := Dictionary new.