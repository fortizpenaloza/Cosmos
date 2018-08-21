Class {
	#name : #MappingRule,
	#superclass : #Object,
	#instVars : [
		'mimeType',
		'mapper'
	],
	#category : #'Cosmos-API-Model'
}

{ #category : #'instance creation' }
MappingRule class >> applying: aMapper for: aMimeType [
	
	^ self new initializeApplying: aMapper for: aMimeType
]

{ #category : #initialization }
MappingRule >> initializeApplying: aMapper for: aMimeType [

	mapper := aMapper.
	mimeType := aMimeType
]

{ #category : #accessing }
MappingRule >> mapper [

	^ mapper
]

{ #category : #accessing }
MappingRule >> mimeType [

	^ mimeType
]
