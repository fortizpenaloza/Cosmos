private-managing
registerNamed: aName triggering: anAction accordingTo: aTriggeringPolicy whenMeets: aTriggeringCondition

	^ self
		triggerNamed: aName
		ifFound: [ :trigger | 
			ObjectAlreadyInSystem
				signal: 'Trigger with that name already exists in system' ]
		ifNone: [ | trigger |

			trigger := ActionTrigger
				named: aName
				createdOn: timeSystem dateTime
				triggering: anAction
				accordingTo: aTriggeringPolicy
				ifSatisfies: aTriggeringCondition.

			self register: trigger accordingTo: aTriggeringPolicy.

			trigger ]