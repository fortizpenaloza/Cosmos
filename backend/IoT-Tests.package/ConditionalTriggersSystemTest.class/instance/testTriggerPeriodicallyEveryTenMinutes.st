tests
testTriggerPeriodicallyEveryTenMinutes

	| triggered conditionalTrigger |

	triggered := false.
	
	conditionalTrigger := ConditionalTrigger
		firing: [ triggered := true ]
		whenMeets: AlwaysTriggeringCondition new
		accordingTo: (PeriodicalTriggeringPolicy every: self tenMinutes).

	self conditionalTriggersSystem register: conditionalTrigger.
	self deny: triggered.

	self conditionalTriggersSystem notifyHavePassed: self fiveMinutes.
	self deny: triggered.

	self conditionalTriggersSystem notifyHavePassed: self tenMinutes.
	self assert: triggered