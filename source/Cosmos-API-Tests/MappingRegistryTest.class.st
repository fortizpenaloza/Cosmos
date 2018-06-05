Class {
	#name : #MappingRegistryTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Tests-Model'
}

{ #category : #tests }
MappingRegistryTest >> testMappingRegistration [

	| mappingRegistry mapping |

	mappingRegistry := MappingRegistry new.

	self
		should: [ mappingRegistry mappingFor: self triggerAsJsonVersion1dot0dot0MimeType ]
		raise: ObjectNotFound
		withDescription: 'Mapping not found in the system'.

	mappingRegistry
		register: self triggerToJsonMappingVersion1dot0dot0
		to: self triggerAsJsonVersion1dot0dot0MimeType.

	mapping := mappingRegistry mappingFor: self triggerAsJsonVersion1dot0dot0MimeType.

	self assert: mapping equals: self triggerToJsonMappingVersion1dot0dot0
]

{ #category : #accessing }
MappingRegistryTest >> triggerAsJsonVersion1dot0dot0MimeType [

	^ ZnMimeType fromString: 'application/vnd.cosmos.trigger+json; version=1.0.0'
]

{ #category : #accessing }
MappingRegistryTest >> triggerToJsonMappingVersion1dot0dot0 [
	
	^ #triggerToJsonMappingVersion1dot0dot0
]
