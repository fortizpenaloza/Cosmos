test
testTriggerPeriodicallyEveryTenMinutes

	| triggered condition triggeringPolicy trigger |

	triggered := false.

	condition := NullTriggerCondition new.
	triggeringPolicy := PeriodicalTriggeringPolicy every: self tenMinutes.
	trigger := ConditionalTrigger
		firing: [ triggered := true ]
		when: condition
		accordingTo: triggeringPolicy.

	self triggerSystem register: trigger.
	self deny: triggered.

	self triggerSystem notifyHavePassed: self fiveMinutes.
	self deny: triggered.

	self triggerSystem notifyHavePassed: self tenMinutes.
	self assert: triggered