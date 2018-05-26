Class {
	#name : #TriggersAPIInstaller,
	#superclass : #Object,
	#instVars : [
		'rootSystem',
		'server'
	],
	#category : 'Cosmos-Triggers-API-Core-Model'
}

{ #category : #'instance creation' }
TriggersAPIInstaller class >> toWorkWith: aCompositeSystem on: aServer [
	
	^ self new initializeToWorkWith: aCompositeSystem on: aServer
]

{ #category : #initialization }
TriggersAPIInstaller >> initializeToWorkWith: aCompositeSystem on: aServer [

	rootSystem := aCompositeSystem .
	server := aServer 
]

{ #category : #initialization }
TriggersAPIInstaller >> install [

	| interface |

	interface := TriggersAPI workingWith: (TriggersAPIContext workingWith: rootSystem).

	server
		GET: '/triggers' -> [ :request | interface triggers ];
		POST: '/triggers' -> [ :request | interface registerFrom: request contents ];
		output: #text;
		DELETE:
			'/triggers/<name>'
				->
					[ :request | interface deregisterNamed: ((request at: #name) replaceAll: $_ with: Character space) ];
		output: #text
]
