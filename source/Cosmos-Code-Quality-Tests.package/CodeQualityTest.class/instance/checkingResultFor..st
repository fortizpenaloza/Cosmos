tests support
checkingResultFor: aRule

	^ (RBSmalllintChecker
		runRule: aRule
		onEnvironment: (RBPackageEnvironment packages: self packagesToBeChecked)) result