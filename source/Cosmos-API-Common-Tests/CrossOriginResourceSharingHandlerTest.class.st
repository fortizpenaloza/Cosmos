Class {
	#name : #CrossOriginResourceSharingHandlerTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Common-Tests-Model'
}

{ #category : #tests }
CrossOriginResourceSharingHandlerTest >> testValue [

	| handler response |

	handler := CrossOriginResourceSharingHandler allowing: #('GET' 'POST').
	response := handler value: (ZnRequest options: 'url').

	self
		assert: response code equals: 204;
		assert: (response headers includesKey: 'Access-Control-Max-Age');
		assert: (response headers includesKey: 'Access-Control-Allow-Headers');
		assert: (response headers includesKey: 'Access-Control-Allow-Methods');
		assert: (response headers at: 'Access-Control-Allow-Methods')
			equals: (Array with: 'GET' with: 'POST')
]
