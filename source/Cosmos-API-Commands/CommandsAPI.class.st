Class {
	#name : #CommandsAPI,
	#superclass : #Object,
	#instVars : [
		'prioritizedCommandMapping',
		'context'
	],
	#category : #'Cosmos-API-Commands'
}

{ #category : #'instance creation' }
CommandsAPI class >> workingWithin: aContext [
	
	^ self new initializeWorkingWithin: aContext
]

{ #category : #systems }
CommandsAPI >> commandManagementSystem [

	^ context systemImplementing: #CommandManagementSystemInterface
]

{ #category : #API }
CommandsAPI >> createCommandBasedOn: aHttpRequest [

	| rawCommand commandWithPriority identifier |

	rawCommand := (NeoJSONReader on: aHttpRequest contents readStream)
		propertyNamesAsSymbols: true;
		next.

	commandWithPriority := CommandWithPriority
		holding: (rawCommand at: #command)
		and: (rawCommand at: #priority).

	self commandManagementSystem register: commandWithPriority.

	identifier := self identifierSystem identifierOf: commandWithPriority.

	^ ZnResponse
		created:
			(ZnUrl
				fromString: ('localhost/<1s>' expandMacrosWith: identifier asString36))
]

{ #category : #decoding }
CommandsAPI >> decode: aKey from: aDictionary with: aParser [

	^ self
		parse: aKey
		from: aDictionary
		with: aParser
		ifNotFound: [ DecodingFailed signal: ('<1s> is mandatory and must be present' expandMacrosWith: aKey) ]
]

{ #category : #'private - systems' }
CommandsAPI >> identifierSystem [

	^ context systemImplementing: #IdentifierSystemInterface
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
CommandsAPI >> initializeWorkingWithin: aContext [

	context := aContext.
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

{ #category : #API }
CommandsAPI >> push: aJSON [

	| rawCommand |

	rawCommand := (NeoJSONReader on: aJSON readStream)
		propertyNamesAsSymbols: true;
		next.

	^ self commandManagementSystem
		enqueue: (rawCommand at: #command)
		with: (rawCommand at:  #priority)
]
