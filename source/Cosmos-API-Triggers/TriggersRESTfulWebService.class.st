Class {
	#name : #TriggersRESTfulWebService,
	#superclass : #RESTfulWebService,
	#instVars : [
		'cosmos'
	],
	#category : #'Cosmos-API-Triggers'
}

{ #category : #'instance creation' }
TriggersRESTfulWebService class >> workingWith: aCosmosSystem [
	
	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #API }
TriggersRESTfulWebService >> createTriggerBasedOn: anHttpRequest within: aContext [

	^ [ self
		withCreatedResourceDo: [ :trigger | self triggerManagementSystem register: trigger ]
		decodedUsing: #triggers
		basedOn: anHttpRequest
		within: (TriggerDecodingContext workingWith: cosmos) ]
		on: InstanceCreationFailed
		do: [ :signal | HTTPClientError signalBadRequest: signal messageText ]
]

{ #category : #API }
TriggersRESTfulWebService >> deregisterNamed: aName [

	| name |

	name := aName replaceAll: $_ with: Character space.

	self triggerManagementSystem deregisterNamed: name.

	^ ZnResponse noContent
]

{ #category : #API }
TriggersRESTfulWebService >> getTriggersBasedOn: anHttpRequest within: aContext [

	^ self
		get: [ self triggerManagementSystem triggers ]
		asCollectionEncodedUsing: #triggers
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #initialization }
TriggersRESTfulWebService >> initializeWorkingWith: aCosmosSystem [

	cosmos := aCosmosSystem
]

{ #category : #'private - accessing' }
TriggersRESTfulWebService >> locationOf: anActionTrigger [ 
	
	^ 1
]

{ #category : #specification }
TriggersRESTfulWebService >> specification [
	
	^ TriggersRESTfulWebServiceSpecification new
]

{ #category : #systems }
TriggersRESTfulWebService >> triggerManagementSystem [
	
	^ cosmos systemImplementing: #TriggerManagementSystemInterface
]
