Class {
	#name : #ReflectiveMappingRuleSetBuilderTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Common-Tests-Model'
}

{ #category : #tests }
ReflectiveMappingRuleSetBuilderTest >> testBuilding [

	| mappingRuleSet |

	mappingRuleSet := (ReflectiveMappingRuleSetBuilder for: PetsWebServiceSpecification new)
		build.
		
	self assert: mappingRuleSet equals: nil
]
