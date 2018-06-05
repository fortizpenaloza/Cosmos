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
TriggersAPI >> registerFrom: aJSON [

	^ [ [ | rawTrigger |

	rawTrigger := (NeoJSONReader on: aJSON readStream)
		propertyNamesAsSymbols: true;
		next.

	self triggerManagementSystem
		registerNamed: (rawTrigger at: #name)
		triggering: (context parseActionFrom: rawTrigger)
		accordingTo: (context parseTriggeringPolicyFrom: rawTrigger)
		whenMeets: (context parseConditionFrom: rawTrigger).

	ZnResponse created: (ZnUrl fromString: 'localhost') ]
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
TriggersAPI >> triggers [

	^ ZnResponse
		ok: (ZnEntity json: (context mapToJson: self triggerManagementSystem triggers))
]
