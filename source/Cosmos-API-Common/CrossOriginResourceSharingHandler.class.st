Class {
	#name : #CrossOriginResourceSharingHandler,
	#superclass : #Object,
	#instVars : [
		'httpMethods'
	],
	#category : #'Cosmos-API-Common-Model'
}

{ #category : #'instance creation' }
CrossOriginResourceSharingHandler class >> allowing: anHttpMethodsCollection [

	^ self new initializeAllowing: anHttpMethodsCollection
]

{ #category : #initializaiton }
CrossOriginResourceSharingHandler >> initializeAllowing: anHttpMethodsCollection [

	httpMethods := anHttpMethodsCollection
]

{ #category : #initializaiton }
CrossOriginResourceSharingHandler >> value: aRequest [

	| response |

	response := ZnResponse noContent.

	response headers
		at: 'Access-Control-Allow-Headers'
			put: 'Access-Control-Allow-Origin, Content-Type, Accept';
		at: 'Access-Control-Allow-Methods' put: self halt;
		at: 'Access-Control-Max-Age' put: '86400'.	"POST, GET, DELETE, PUT"

	^ response
]
