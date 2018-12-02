Class {
	#name : #ArchitectureCodeQualityTest,
	#superclass : #TestCase,
	#category : 'Cosmos-Code-Quality-Tests'
}

{ #category : #tests }
ArchitectureCodeQualityTest >> testSystemsMustImplementAllMessagesDeclaredInItsInterface [

	| systems |

	systems := SubsystemImplementation allSubclasses
		reject: [ :class | class implementedInterface isImplementedByInstancesOf: class ].

	self
		assert: systems isEmpty
		description:
			('At least one system implementation has defined all expected messages (declared by its implemented interface) (See <1s>)'
				expandMacrosWith: systems asString)
]
