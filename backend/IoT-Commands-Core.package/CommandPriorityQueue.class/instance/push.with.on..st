pushing
push: aCommand with: aPriority on: aDateTime

	| prioritizedCommand |

	prioritizedCommand := PrioritizedCommand
		holding: aCommand
		with: aPriority
		on: aDateTime.

	priorityQueue push: prioritizedCommand with: aPriority.
	prioritizedCommands add: prioritizedCommand