Class {
	#name : #TriggersAPIInstaller,
	#superclass : #Object,
	#instVars : [
		'server',
		'interface',
		'mappingRegistry'
	],
	#category : #'Cosmos-API-Triggers-Model'
}

{ #category : #'instance creation' }
TriggersAPIInstaller class >> toInstallOn: aServer workingWith: aCosmosSystem [

	^ self new initializeToInstallOn: aServer workingWith: aCosmosSystem
]

{ #category : #'private-installing' }
TriggersAPIInstaller >> addGetTriggersRoute [

	server GET: '/triggers' -> [ :request | interface triggers ]
	
	"mappingSystem := compositeSystem systemImplementing: #MappingManagementSystem.
	
	mappingSystem register: aMapping with: aMimeType.
	
	mappingSystem get: aMimeType"
	
	
	
	

]

{ #category : #'private-installing' }
TriggersAPIInstaller >> addRegisterTriggerRoute [

	server
		POST: '/triggers' -> [ :request | interface registerFrom: request contents ];
		output: #text
]

{ #category : #'private-installing' }
TriggersAPIInstaller >> addUnregisterTriggerRoute [

	server
		DELETE:
			'/triggers/<name>'
				-> [ :request | 
					interface
						deregisterNamed: ((request at: #name) replaceAll: $_ with: Character space) ];
		output: #text
]

{ #category : #initialization }
TriggersAPIInstaller >> initializeToInstallOn: aServer workingWith: aCosmosSystem [

	mappingRegistry := MappingRegistry new.
	interface := TriggersAPI workingWithin: (TriggersAPIContext workingWith: aCosmosSystem).
	server := aServer
]

{ #category : #installing }
TriggersAPIInstaller >> install [

	self
		addGetTriggersRoute;
		addRegisterTriggerRoute;
		addUnregisterTriggerRoute
]
