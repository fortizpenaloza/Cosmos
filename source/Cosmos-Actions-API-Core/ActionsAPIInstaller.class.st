Class {
	#name : #ActionsAPIInstaller,
	#superclass : #Object,
	#instVars : [
		'server',
		'interface',
		'mappingRegistry'
	],
	#category : #'Cosmos-Actions-API-Core-Model'
}

{ #category : #'instance creation' }
ActionsAPIInstaller class >> toInstallOn: aServer workingWith: aCosmosSystem [

	^ self new initializeToInstallOn: aServer workingWith: aCosmosSystem
]

{ #category : #'private-installing' }
ActionsAPIInstaller >> addDeregisterActionRoute [

	server
		DELETE:
			'/actions/<name>'
				-> [ :request | interface deregisterNamed: (request at: #name) ];
		output: #text
]

{ #category : #'private-installing' }
ActionsAPIInstaller >> addGetActionsRoute [

	server GET: '/actions' -> [ :request | interface actions ]
]

{ #category : #'private-installing' }
ActionsAPIInstaller >> addRegisterActionRoute [

	server
		POST: '/actions' -> [ :request | interface registerFrom: request contents ]
]

{ #category : #initialization }
ActionsAPIInstaller >> initializeToInstallOn: aServer workingWith: aCosmosSystem [

	mappingRegistry := MappingRegistry new.
	interface := ActionsAPI workingWithin: (ActionsAPIContext workingWith: aCosmosSystem  queryingMappingsTo: mappingRegistry).
	server := aServer
]

{ #category : #installing }
ActionsAPIInstaller >> install [

	self
		addGetActionsRoute;
		addRegisterActionRoute;
		addDeregisterActionRoute.

	^ interface
]
