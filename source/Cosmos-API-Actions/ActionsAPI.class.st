Class {
	#name : #ActionsAPI,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'Cosmos-API-Actions'
}

{ #category : #'instance creation' }
ActionsAPI class >> workingWithin: aContext [
	
	^ self new initializeWorkingWithin: aContext 
]

{ #category : #systems }
ActionsAPI >> actionManagementSystem [

	^ context actionManagementSystem
]

{ #category : #API }
ActionsAPI >> actionsFor: anHttpRequest [

	| mimeType |

	mimeType := ZnMimeType fromString: anHttpRequest accept.

	^ [ [ ZnResponse
		ok:
			(ZnEntity
				json: (context encode: self actionManagementSystem actions to: mimeType within: #actions)) ]
		on: ConflictingObjectFound
		do: [ :signal | HTTPClientError signalConflict: signal messageText ] ]
		on: ObjectNotFound
		do: [ :signal | HTTPClientError signalBadRequest: signal messageText ]
]

{ #category : #API }
ActionsAPI >> deregisterNamed: aName [

	|name | 
	
	name := aName replaceAll: $_ with: Character space.
	
	self actionManagementSystem deregisterNamed: name.

	^ ZnResponse noContent
]

{ #category : #initialization }
ActionsAPI >> initializeWorkingWithin: aContext [

	context := aContext
]

{ #category : #API }
ActionsAPI >> registerHandling: aJSON [

	^ [ [ | rawAction |

	rawAction := (NeoJSONReader on: aJSON readStream)
		propertyNamesAsSymbols: true;
		next.

	self actionManagementSystem
		registerNamed: (context parseNameFrom: rawAction)
		toEvaluate: (context parseRequestFrom: rawAction).

	ZnResponse created: (ZnUrl fromString: 'localhost') ]
		on: ConflictingObjectFound
		do: [ :signal | HTTPClientError signalConflict: signal messageText ] ]
		on: KeyNotFound , DecodingFailed
		do: [ :signal | 
			HTTPClientError
				signalBadRequest: ('Expected key <1s> was not found' expandMacrosWith: signal key) ]
]
