initialize-release
initializeSubsystemOf: aParentSystem

	aParentSystem register: self as: #feedsSystem.
	parentSystem := aParentSystem.
	
	numbering := 	SequentialNumberProvider new.
	feeds := Dictionary new.