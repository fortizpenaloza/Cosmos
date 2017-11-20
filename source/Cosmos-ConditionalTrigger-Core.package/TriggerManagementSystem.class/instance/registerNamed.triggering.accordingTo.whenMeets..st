private-managing
registerNamed: aName triggering: anAction accordingTo: aTriggeringPolicy whenMeets: aTriggeringCondition

	^ self
		triggerNamed: aName
		ifFound: [ :trigger | 
			ObjectAlreadyInSystem
				signal: 'Trigger with that name already exists in system' ]
		ifNone: [ | trigger registeredTrigger |

			trigger := Trigger
				named: aName
				createdOn: timeSystem dateTime
				triggering: anAction
				whenMeets: aTriggeringCondition.

			registeredTrigger := RegisteredTrigger
				holding: trigger
				accordingTo: aTriggeringPolicy.

			self register: registeredTrigger.

			registeredTrigger ]