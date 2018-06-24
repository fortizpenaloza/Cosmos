Class {
	#name : #CommandsAPI,
	#superclass : #Object,
	#instVars : [
		'rootSystem',
		'prioritizedCommandMapping'
	],
	#category : #'Cosmos-API-Commands'
}

{ #category : #'instance creation' }
CommandsAPI class >> workingWith: aCompositeSystem [

	^ self new initializeWorkingWith: aCompositeSystem 
]

{ #category : #systems }
CommandsAPI >> commandManagementSystem [

	^ rootSystem systemImplementing: #CommandManagementSystemInterface
]

{ #category : #decoding }
CommandsAPI >> decode: aKey from: aDictionary with: aParser [

	^ self
		parse: aKey
		from: aDictionary
		with: aParser
		ifNotFound: [ DecodingFailed signal: ('<1s> is mandatory and must be present' expandMacrosWith: aKey) ]
]

{ #category : #'initialize-release' }
CommandsAPI >> initializeMappings [

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
CommandsAPI >> initializeWorkingWith: aCompositeSystem [

	rootSystem := aCompositeSystem.
	self initializeMappings
]

{ #category : #querying }
CommandsAPI >> nextCommandAsJSON [

	^ prioritizedCommandMapping
		value: self commandManagementSystem dequeue
]

{ #category : #querying }
CommandsAPI >> nextCommandAsPlainText [

	^ self commandManagementSystem dequeue command
]

{ #category : #decoding }
CommandsAPI >> parse: aKey from: aDictionary with: aParser ifNotFound: aNotFoundBlock [

	^ aDictionary
		at: aKey
		ifPresent: [ :rawData | aParser value: rawData ]
		ifAbsent: aNotFoundBlock
]

{ #category : #querying }
CommandsAPI >> prioritizedCommands [

	^ prioritizedCommandMapping value: (self commandManagementSystem prioritizedCommands )
]

{ #category : #parsers }
CommandsAPI >> priorityParser [

	| priorities |

	priorities := Dictionary new
		at: 'high' put: QueuePriority high;
		at: 'medium' put: QueuePriority medium;
		at: 'low' put: QueuePriority low;
		yourself.

	^ [ :string | priorities at: string ifAbsent: [ DecodingFailed signal: 'lalal' ] ]
]

{ #category : #'pushing-popping' }
CommandsAPI >> push: aJSON [

	| rawCommand |

	rawCommand := (NeoJSONReader on: aJSON readStream)
		propertyNamesAsSymbols: true;
		next.

	^ self commandManagementSystem
		enqueue: (rawCommand at: #command)
		with: (self decode: #priority from: rawCommand with: self priorityParser)
]
