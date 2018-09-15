Class {
	#name : #RouteSpecificationTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Tests-Model'
}

{ #category : #tests }
RouteSpecificationTest >> testInstanceCreationAndAccessing [

	| teapot route |
	
	teapot := Teapot on.
	
	route := RouteSpecification 
		handling: #GET
		at: '/pets' 
		sending: #getPetsBasedOn:within:.
		
	self assert: route httpMethod equals: #GET;
		assert: route resourceLocation equals: '/pets';
		assert: route message equals: #getPetsBasedOn:within:
]
