Class {
	#name : #ArchitectureCodeQualityTest,
	#superclass : #TestCase,
	#pools : [
		'Kepler'
	],
	#category : #'Cosmos-Code-Quality-Tests'
}

{ #category : #tests }
ArchitectureCodeQualityTest >> testSystemsMustImplementAllMessagesDeclaredInItsInterface [

	| subsystemClassesNotImplementingInterfaces |

	subsystemClassesNotImplementingInterfaces := SubsystemImplementation allSubclasses
		reject: [ :class | 
			class new implementedInterfaces
				allSatisfy: [ :interface | (SystemInterfaces >> interface) isImplementedByInstancesOf: class ] ].

	self
		assert: subsystemClassesNotImplementingInterfaces isEmpty
		description:
			('At least one system implementation has defined all expected messages (declared by its implemented interface) (See <1s>)'
				expandMacrosWith: subsystemClassesNotImplementingInterfaces asString)
]
