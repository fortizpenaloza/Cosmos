Class {
	#name : #CommandsAPIInstaller,
	#superclass : #Object,
	#instVars : [
		'mappingRegistry',
		'interface',
		'server'
	],
	#category : #'Cosmos-API-Commands'
}

{ #category : #'instance creation' }
CommandsAPIInstaller class >> toInstallOn: aServer workingWith: aCosmosSystem [

	^ self new initializeToInstallOn: aServer workingWith: aCosmosSystem
]

{ #category : #'private - installing routes' }
CommandsAPIInstaller >> addCreateCommandsRoute [
	
	server 
		POST: '/commands' -> [ :request | interface createCommandBasedOn: request ]
]

{ #category : #'private - installing routes' }
CommandsAPIInstaller >> addCreateMetadataRoute [

	server
		POST: '/commands/<identifier:IsUUID>/metadata' -> [ :request | interface createMetadataBasedOn: request ]
]

{ #category : #'private - installing routes' }
CommandsAPIInstaller >> addDeleteCommandsRoute [

	server DELETE: '/commands/<identifier:IsUUID>' -> [ :request | interface deleteCommandBasedOn: request ]
]

{ #category : #'private - installing routes' }
CommandsAPIInstaller >> addGetCommandsRoute [
	
	server 
		GET: '/commands' -> [ :request | interface getCommandsBasedOn: request ]
]

{ #category : #'private - installing routes' }
CommandsAPIInstaller >> addNextCommandRoute [

	server POST: '/commands/next' -> [ :request | interface nextCommandBasedOn: request ]
]

{ #category : #initialization }
CommandsAPIInstaller >> initializeToInstallOn: aServer workingWith: aCosmosSystem [

	mappingRegistry := MappingRegistry new.
	interface := CommandsAPI
		workingWithin: (CommandsAPIContext workingWith: aCosmosSystem queryingMappingsTo: mappingRegistry).
	server := aServer
]

{ #category : #installing }
CommandsAPIInstaller >> install [

	self
		addCreateCommandsRoute;
		addGetCommandsRoute;
		addDeleteCommandsRoute;
		addCreateMetadataRoute;
		addNextCommandRoute.
				
	^ interface
]
