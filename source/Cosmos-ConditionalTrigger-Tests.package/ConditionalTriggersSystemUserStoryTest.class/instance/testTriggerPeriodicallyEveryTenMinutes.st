tests
testTriggerPeriodicallyEveryTenMinutes

	| conditionalTrigger |

	self eventNotificationSystem
		subscribe: self
		to: EvaluateActionEvent
		toBeNotifiedSending: #setTriggeredToTrue.

	conditionalTrigger := ConditionalTrigger
		firing: 'Set triggered to true'
		whenMeets: AlwaysTriggeringCondition new
		accordingTo: (PeriodicalTriggeringPolicy every: self tenMinutes).

	self conditionalTriggersSystem register: conditionalTrigger.
	self deny: triggered.

	self conditionalTriggersSystem havePassed: self fiveMinutes.
	self deny: triggered.

	self conditionalTriggersSystem havePassed: self tenMinutes.
	self assert: triggered