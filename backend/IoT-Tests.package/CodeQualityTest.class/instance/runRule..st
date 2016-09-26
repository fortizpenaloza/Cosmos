tests support
runRule: aRule

	^ (RBSmalllintChecker
		runRule: aRule
		onEnvironment: (RBPackageEnvironment packageNames: self packagesToBeChecked)) result