actions
registerInterfaceAs: aKey named: aName declaring: aSelectorSet

	SystemInterface
		bind: aKey
		to: (Interface named: aName declaring: aSelectorSet) 