tests
testInstanceCreationAndAccessing

	| trigger triggered |
	
	triggered := false.

	trigger := Trigger
		named: 'Set triggered to true'
		createdOn: self septemberSixthOf2014AtNoon
		triggering: [ triggered := true ]
		whenMeets: AlwaysTriggeringCondition new.

	self
		assert: trigger name equals: 'Set triggered to true';
		assert: trigger creationDateTime equals: self septemberSixthOf2014AtNoon;
		deny: triggered.
		
	trigger ifSatisfiedOn: nil withActionDo: [ :action | action value ].
	self assert: triggered