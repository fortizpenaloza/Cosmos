tests
testImplemetedInterfacesMustDeclareAtLeastOneMessage

	| systems |

	systems := System allSubclasses
		reject: [ :class | class implementedInterface messages notEmpty ].
		
	self
		assert: systems isEmpty
		description:
			('At least, one system implementation does not define the protocol of the interface it implements (check <1s>)'
				expandMacrosWith: systems asString)