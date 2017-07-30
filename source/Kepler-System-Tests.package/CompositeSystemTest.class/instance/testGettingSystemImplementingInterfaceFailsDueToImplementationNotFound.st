tests
testGettingSystemImplementingInterfaceFailsDueToImplementationNotFound

	| system |

	system := CompositeSystem of: #().

	self
		should: [ system systemImplementing: Interfaces >> #TimeSystemInterface ]
		raise: SystemImplementationNotFound