tests
testSystemsMustImplementAllMessagesDeclaredInItsInterface

	| systems |

	systems := System allSubclasses
		reject: [ :class | class implementedInterface isImplementedByInstancesOf: class ].

	self
		assert: systems isEmpty
		description:
			('At least one system implementation has defined all expected messages (declared by its implemented interface) (See <1s>)'
				expandMacrosWith: systems asString)