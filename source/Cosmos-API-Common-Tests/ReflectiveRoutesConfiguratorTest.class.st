Class {
	#name : #ReflectiveRoutesConfiguratorTest,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'Cosmos-API-Common-Tests-Model'
}

{ #category : #tests }
ReflectiveRoutesConfiguratorTest >> testAddingRoutes [

	| teapot webService |

	teapot := Teapot on.

	webService := PetsWebService workingWith: rootSystem.

	(ReflectiveRoutesConfigurator appliedTo: teapot) 
		addRoutesOf: webService.

	self assert: teapot routes size equals: 3
]
