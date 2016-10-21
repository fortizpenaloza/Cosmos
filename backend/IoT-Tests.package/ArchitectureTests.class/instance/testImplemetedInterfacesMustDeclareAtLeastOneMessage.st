tests
testImplemetedInterfacesMustDeclareAtLeastOneMessage

	| systems |

	systems := System allSubclasses
		reject: [ :class | class implementedInterface messages notEmpty ].
		
	self
		assert: systems isEmpty
		description:
			('Al menos una implementación de un sistema no define protocolo en la interfaz que implementa (revisar <1s>)'
				expandMacrosWith: systems asString)