Class {
	#name : #MappingRule,
	#superclass : #Object,
	#instVars : [
		'mimeType',
		'mapper',
		'scope',
		'isDefault'
	],
	#category : #'Cosmos-API-Model'
}

{ #category : #'instance creation' }
MappingRule class >> applying: aMapper for: aMimeType at: aScope [

	^ self new
		initializeApplying: aMapper
		for: aMimeType
		at: aScope
]

{ #category : #accessing }
MappingRule >> beDefault [

	isDefault := true
]

{ #category : #initialization }
MappingRule >> initializeApplying: aMapper for: aMimeType at: aScope [ 

	mapper := aMapper.
	mimeType := aMimeType.
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
MappingRule >> mimeType [

	^ mimeType
]

{ #category : #accessing }
MappingRule >> scope [

	^ scope
]
