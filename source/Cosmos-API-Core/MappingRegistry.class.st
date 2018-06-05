Class {
	#name : #MappingRegistry,
	#superclass : #Object,
	#instVars : [
		'mappings'
	],
	#category : #'Cosmos-API-Core-Model'
}

{ #category : #'dependency resolution' }
MappingRegistry >> initialize [

	mappings := Dictionary new
]

{ #category : #managing }
MappingRegistry >> mappingFor: aSchema [

	^ mappings
		at: aSchema
		ifAbsent: [ ObjectNotFound signal: 'Mapping not found in the system' ]
]

{ #category : #managing }
MappingRegistry >> register: aMapping to: aSchema [
	
	mappings at: aSchema put: aMapping
]
