pushing-popping
pop

	| priorizedCommand |

	priorizedCommand := self popIfEmptyDo: [ QueueIsEmpty signal: 'Queue is empty' ].
	priorizedCommands remove: priorizedCommand.
	^ priorizedCommand