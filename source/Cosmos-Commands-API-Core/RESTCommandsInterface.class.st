Class {
	#name : #RESTCommandsInterface,
	#superclass : #Object,
	#instVars : [
		'rootSystem',
		'prioritizedCommandMapping'
	],
	#category : 'Cosmos-Commands-API-Core'
}

{ #category : #'instance creation' }
RESTCommandsInterface class >> workingWith: aCompositeSystem [

	^ self new initializeWorkingWith: aCompositeSystem 
]

{ #category : #systems }
RESTCommandsInterface >> commandManagementSystem [

	^ rootSystem systemImplementing: #CommandManagementSystemInterface
]

{ #category : #'initialize-release' }
RESTCommandsInterface >> initializeMappings [

	prioritizedCommandMapping := [ :object | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: PrioritizedCommand
					do: [ :mapping | 
					mapping
						mapAccessor: #command;
						mapAccessor: #priority ];
				for: HighPriority customDo: [ :mapping | mapping encoder: [ :priority | 'High' ] ];
				prettyPrint: true;
				nextPut: object ] ]
]

{ #category : #'initialize-release' }
RESTCommandsInterface >> initializeWorkingWith: aCompositeSystem [

	rootSystem := aCompositeSystem.
	self initializeMappings
]

{ #category : #querying }
RESTCommandsInterface >> nextCommandAsJSON [

	^ prioritizedCommandMapping
		value: self commandManagementSystem dequeue
]

{ #category : #querying }
RESTCommandsInterface >> nextCommandAsPlainText [

	^ self commandManagementSystem dequeue command
]

{ #category : #parsing }
RESTCommandsInterface >> parse: aString with: aParser [ 

	^ aParser parse: aString
]

{ #category : #querying }
RESTCommandsInterface >> prioritizedCommands [

	^ prioritizedCommandMapping value: (self commandManagementSystem prioritizedCommands )
]

{ #category : #parsers }
RESTCommandsInterface >> priorityParser [

	^ CaseBasedParser new
		parsing: 'high' to: QueuePriority high;
		parsing: 'medium' to: QueuePriority medium;
		parsing: 'low' to: QueuePriority low;
		yourself.

]

{ #category : #'pushing-popping' }
RESTCommandsInterface >> push: aJSON [

	| rawCommand |

	rawCommand := (NeoJSONReader on: aJSON readStream)
		propertyNamesAsSymbols: true;
		next.

	^ self commandManagementSystem
		enqueue: (rawCommand at: #command)
		with: (self parse: (rawCommand at: #priority) with: self priorityParser)
]
