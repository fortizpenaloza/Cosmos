Class {
	#name : #ActionsWebService,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'Cosmos-API-Actions'
}

{ #category : #'instance creation' }
ActionsWebService class >> workingWithin: aContext [
	
	^ self new initializeWorkingWithin: aContext 
]

{ #category : #systems }
ActionsWebService >> actionManagementSystem [

	^ context actionManagementSystem
]

{ #category : #API }
ActionsWebService >> actionsFor: anHttpRequest [

	| mimeType |

	mimeType := ZnMimeType fromString: anHttpRequest accept.

	^ [ [ ZnResponse
		ok:
			(ZnEntity
				json:
					(context
						encode: self actionManagementSystem actions
						of: #actions
						to: mimeType
						within: aContext)) ]
		on: ConflictingObjectFound
		do: [ :signal | HTTPClientError signalConflict: signal messageText ] ]
		on: ObjectNotFound
		do: [ :signal | HTTPClientError signalBadRequest: signal messageText ]
]

{ #category : #API }
ActionsWebService >> deregisterNamed: aName [

	|name | 
	
	name := aName replaceAll: $_ with: Character space.
	
	self actionManagementSystem deregisterNamed: name.

	^ ZnResponse noContent
]

{ #category : #initialization }
ActionsWebService >> initializeWorkingWithin: aContext [

	context := aContext
]

{ #category : #API }
ActionsWebService >> registerHandling: aJSON [

	| action |
	^ [ [ | rawAction |

	rawAction := (NeoJSONReader on: aJSON readStream)
		propertyNamesAsSymbols: true;
		next.

	action := Action named: (context parseNameFrom: rawAction)
		evaluating: (SendHttpRequestPolicy sending: (context parseRequestFrom: rawAction)).
	
	self actionManagementSystem register: action.

	ZnResponse created: (ZnUrl fromString: 'localhost') ]
		on: ConflictingObjectFound
		do: [ :signal | HTTPClientError signalConflict: signal messageText ] ]
		on: KeyNotFound , DecodingFailed
		do: [ :signal | 
			HTTPClientError
				signalBadRequest: ('Expected key <1s> was not found' expandMacrosWith: signal key) ]
]
