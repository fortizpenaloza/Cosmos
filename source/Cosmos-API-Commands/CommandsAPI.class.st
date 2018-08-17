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

{ #category : #initialization }
CommandsAPI >> initializeMappings [

	prioritizedCommandMapping := [ :object | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: CommandWithPriority
					do: [ :mapping | 
					mapping
						mapAccessor: #command;
						mapAccessor: #priority ];
				prettyPrint: true;
				nextPut: object ] ]
]

{ #category : #initialization }
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

	^ prioritizedCommandMapping value: (self commandManagementSystem commands )
]

{ #category : #'pushing-popping' }
CommandsAPI >> push: aJSON [

	| rawCommand |

	rawCommand := (NeoJSONReader on: aJSON readStream)
		propertyNamesAsSymbols: true;
		next.

	^ self commandManagementSystem
		enqueue: (rawCommand at: #command)
		with: (rawCommand at:  #priority)
]
