Class {
	#name : #MappingRule,
	#superclass : #Object,
	#instVars : [
		'mapper',
		'scope',
		'isDefault',
		'mediaType'
	],
	#category : #'Cosmos-API-Model'
}

{ #category : #'instance creation' }
MappingRule class >> applying: aMapper for: aMediaType within: aScope [

	^ self new
		initializeApplying: aMapper
		for: aMediaType
		within: aScope
]

{ #category : #accessing }
MappingRule >> beDefault [

	isDefault := true
]

{ #category : #initialization }
MappingRule >> initializeApplying: aMapper for: aMediaType within: aScope [ 

	mapper := aMapper.
	mediaType := aMediaType.
	scope := aScope.
	isDefault := false
]

{ #category : #testing }
MappingRule >> isDefault [

	^ isDefault
]

{ #category : #accessing }
MappingRule >> mapper [

	^ mapper
]

{ #category : #accessing }
MappingRule >> mediaType [

	^ mediaType
]

{ #category : #accessing }
MappingRule >> scope [

	^ scope
]
