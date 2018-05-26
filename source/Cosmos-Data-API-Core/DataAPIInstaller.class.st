Class {
	#name : #DataAPIInstaller,
	#superclass : #Object,
	#instVars : [
		'system',
		'server'
	],
	#category : 'Cosmos-Data-API-Core'
}

{ #category : #'instance creation' }
DataAPIInstaller class >> toWorkWith: aCompositeSystem on: aServer [
	
	^ self new initializeToWorkWith: aCompositeSystem on: aServer
]

{ #category : #'initialize-release' }
DataAPIInstaller >> initializeToWorkWith: aCompositeSystem on: aServer [

	system := aCompositeSystem .
	server := aServer 
]

{ #category : #installing }
DataAPIInstaller >> install [

	| interface |

	interface := DataAPI workingWith: system.

	server
		GET: '/data-streams' -> [ :request | interface streams ];
		"streamsSnapshot"
			GET: '/data-streams/<name>' -> [ :request | interface streamNamed: (request at: #name) ];
		POST: '/data-streams' -> [ :request | interface registerStreamFrom: request contents ];
		output: #text;
		POST: '/data-points' -> [ :request | interface registerBulkPointsFrom: request contents ];
		output: #text
]
