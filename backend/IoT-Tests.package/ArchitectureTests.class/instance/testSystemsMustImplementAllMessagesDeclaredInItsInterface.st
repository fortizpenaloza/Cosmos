tests
testSystemsMustImplementAllMessagesDeclaredInItsInterface

	| systems |

	systems := System allSubclasses
		reject:
			[ :class | class organization allMethodSelectors includesAll: class implementedInterface messages ].
		
	self assert: systems isEmpty