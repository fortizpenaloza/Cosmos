tests support
runRule: aRule

	^ (RBSmalllintChecker
		runRule: aRule
		onEnvironment: (RBPackageEnvironment packages: self packagesToBeChecked)) result