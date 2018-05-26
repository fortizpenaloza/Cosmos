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
ActionsAPIInstaller class >> toWorkWith: aCompositeSystem on: aServer [
	
	^ self new initializeToWorkWith: aCompositeSystem on: aServer
]

{ #category : #initialization }
ActionsAPIInstaller >> initializeToWorkWith: aCompositeSystem on: aServer [

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
