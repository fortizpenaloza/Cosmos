Class {
	#name : #TriggersAPI,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'Cosmos-API-Triggers-Model'
}

{ #category : #'instance creation' }
TriggersAPI class >> workingWithin: aContext [ 
	
	^ self new initializeWorkingWithin: aContext 
]

{ #category : #API }
TriggersAPI >> deregisterNamed: aName [

	| name |

	name := aName replaceAll: $_ with: Character space.

	self triggerManagementSystem deregisterNamed: name.

	^ ZnResponse noContent
]

{ #category : #initialization }
TriggersAPI >> initializeWorkingWithin: aContext [

	context := aContext
]

{ #category : #API }
TriggersAPI >> registerFrom: anHttpRequest [

	^ [ [ context
		register: anHttpRequest contents
		encodedAs: anHttpRequest contentType.

	ZnResponse created: anHttpRequest requestLine uri ]
		on: ConflictingObjectFound
		do: [ :signal | HTTPClientError signalConflict: signal messageText ] ]
		on: KeyNotFound , ParsingFailed
		do: [ :signal | 
			HTTPClientError
				signalBadRequest:
					('{"error":{"code":400,"message":"Expected key <1s> was not found"}'
						expandMacrosWith: signal key) ]
]

{ #category : #systems }
TriggersAPI >> triggerManagementSystem [
	
	^ context triggerManagementSystem
]

{ #category : #API }
TriggersAPI >> triggersFor: anHttpRequest [

	| mimeType |

	mimeType := ZnMimeType fromString: anHttpRequest accept.

	^ ZnResponse
		ok: (ZnEntity json: (context encode: self triggerManagementSystem triggers to: mimeType))
]
