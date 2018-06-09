Class {
	#name : #ActionsAPIInstaller,
	#superclass : #Object,
	#instVars : [
		'rootSystem',
		'server'
	],
	#category : 'Cosmos-Actions-API-Core-Model'
}

{ #category : #'instance creation' }
ActionsAPIInstaller class >> toInstallOn: aServer workingWith: aCosmosSystem [

	^ self new initializeToInstallOn: aServer workingWith: aCosmosSystem
]

{ #category : #initialization }
ActionsAPIInstaller >> initializeToInstallOn: aServer workingWith: aCompositeSystem [

	rootSystem := aCompositeSystem .
	server := aServer 
]

{ #category : #installing }
ActionsAPIInstaller >> install [

	| interface |

	interface := ActionsAPI workingWith: (ActionsAPIContext workingWith: rootSystem).

	server
		GET: '/actions' -> [ :request | interface actions ];
		POST: '/actions' -> [ :request | interface registerFrom: request contents ];
		DELETE:
			'/actions/<name>' -> [ :request | interface deregisterNamed: (request at: #name) ];
		output: #text
]
