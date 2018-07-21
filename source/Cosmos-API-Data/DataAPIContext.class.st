Class {
	#name : #DataAPIContext,
	#superclass : #Object,
	#instVars : [
		'cosmos',
		'mappingRegistry'
	],
	#category : #'Cosmos-API-Data'
}

{ #category : #'instance creation' }
DataAPIContext class >> workingWith: aCosmosSystem queryingMappingsTo: aMappingRegistry [ 

	^ self new initializeWorkingWith: aCosmosSystem queryingMappingsTo: aMappingRegistry
]

{ #category : #systems }
DataAPIContext >> dataManagementSystem [
	
	^ cosmos systemImplementing: #DataManagementSystemInterface
]

{ #category : #decoding }
DataAPIContext >> decode: aJSON encodedAs: aMimeType [

	| decoder |

	decoder := mappingRegistry decoderFor: aMimeType.
	^ decoder cull: aJSON

]

{ #category : #'as yet unclassified' }
DataAPIContext >> encode: anObject to: aMimeType [

	^ (mappingRegistry encoderFor: aMimeType) value: anObject
]

{ #category : #initialization }
DataAPIContext >> initializeWorkingWith: aCosmosSystem queryingMappingsTo:  
	aMappingRegistry [

	cosmos := aCosmosSystem.
	mappingRegistry := aMappingRegistry
]

{ #category : #managing }
DataAPIContext >> register: aValue toStreamNamed: aName [

	^ self dataManagementSystem register: aValue toStreamNamed: aName
]
