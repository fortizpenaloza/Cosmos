test
testTriggerPeriodicallyEveryTenMinutesIfDataStreamCurrentValueOnTimeInterval

	| triggered dataChannel dataStream triggerCondition triggeringPolicy trigger |

	triggered := false.
	dataChannel := self dataManagementSystem registerChannelNamed: 'Channel #1'.
	dataStream := self dataManagementSystem
		registerStreamNamed: 'test' toChannelIdentifiedBy: dataChannel identifier.
		
	triggerCondition := AndCompositeTriggeringCondition
		with:
			(DataStreamCurrentValueTriggeringCondition
				of: dataStream
				isLessThan: 11)
		with:
			(TimeIntervalTriggeringCondition
				querying: self timeSystem
				toBeBetween: (self eightPM to: self ninePM)).
	triggeringPolicy := PeriodicalTriggeringPolicy every: self tenMinutes.
	trigger := ConditionalTrigger
		firing: [ triggered := true ]
		when: triggerCondition
		accordingTo: triggeringPolicy.
	
	self triggerSystem register: trigger.
	self deny: triggered.
	
	self triggerSystem notifyHavePassed: self tenMinutes.
	self deny: triggered.
	
	timeSource setTimeTo: self eightPM.
	self triggerSystem notifyHavePassed: self tenMinutes.
	self assert: triggered