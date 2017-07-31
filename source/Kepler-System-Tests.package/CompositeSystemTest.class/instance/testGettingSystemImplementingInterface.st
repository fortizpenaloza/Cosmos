tests
testGettingSystemImplementingInterface

	| system timeSystem |

	timeSystem := self timeSystem.

	system := CompositeSystem of: (Array with: timeSystem).

	self
		assert: (system systemImplementing: Interfaces >> #TimeSystemInterface)
		equals: timeSystem