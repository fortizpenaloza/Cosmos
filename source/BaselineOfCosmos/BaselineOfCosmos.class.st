Class {
	#name : #BaselineOfCosmos,
	#superclass : #BaselineOf,
	#category : 'BaselineOfCosmos'
}

{ #category : #baselines }
BaselineOfCosmos >> baseline: spec [

	<baseline>
	spec
		for: #common
		do: [ self setUpDependencies: spec.
			self
				describeModelDependenciesOn: spec;
				describeAPIDependenciesOn: spec;
				describeModelTestsDependenciesOn: spec;
				describeAPITestsDependenciesOn: spec.

			spec package: 'Cosmos-Code-Quality-Tests'.

			spec
				package: 'Cosmos'
				with: [ spec requires: #('Teapot' 'Kepler' 'Cosmos-Data-API-Core') ].

			spec package: 'Cosmos-Tools' with: [ spec requires: #('Roassal2') ].

			spec
				group: 'Deployment'
					with:
					#('Cosmos-Data-Core' 'Cosmos-Triggers-Core' 'Cosmos-Commands-Core' 'Cosmos-Actions-Core' 'Cosmos-PeriodicalScheduler-Core' 'Cosmos-ActionEvaluator-Core' 'Cosmos-API-Core' 'Cosmos-Data-API-Core' 'Cosmos-Commands-API-Core' 'Cosmos-Actions-API-Core' 'Cosmos-API-Triggers' 'Cosmos');
				group: 'Tests'
					with:
					#('Cosmos-Tests' 'Cosmos-UserStoryTests' 'Cosmos-Data-Tests' 'Cosmos-Triggers-Tests' 'Cosmos-Commands-Tests' 'Cosmos-Actions-Tests' 'Cosmos-PeriodicalScheduler-Tests' 'Cosmos-ActionEvaluator-Tests' 'Cosmos-API-Tests' 'Cosmos-Data-API-Tests' 'Cosmos-Commands-API-Tests' 'Cosmos-Actions-API-Tests' 'Cosmos-API-Triggers-Tests' 'Cosmos-Code-Quality-Tests');
				group: 'Tools' with: #('Cosmos-Tools');
				group: 'CI' with: #('Deployment' 'Tests');
				group: 'Development' with: #('CI' 'Tools');
				group: 'default' with: #('Deployment').
			spec postLoadDoIt: #postload:package: ]
]

{ #category : #'private-baselines' }
BaselineOfCosmos >> describeAPIDependenciesOn: spec [

	spec
		package: 'Cosmos-API-Core' with: [ spec requires: 'Teapot' ];
		package: 'Cosmos-Data-API-Core'
			with: [ spec requires: #('Cosmos-API-Core' 'Cosmos-Data-Core') ];
		package: 'Cosmos-Commands-API-Core'
			with: [ spec requires: #('Cosmos-API-Core' 'Cosmos-Commands-Core') ];
		package: 'Cosmos-Actions-API-Core'
			with: [ spec requires: #('Cosmos-API-Core' 'Cosmos-Actions-Core') ];
		package: 'Cosmos-API-Triggers'
			with: [ spec requires: #('Cosmos-API-Core' 'Cosmos-Triggers-Core') ]
]

{ #category : #baselines }
BaselineOfCosmos >> describeAPITestsDependenciesOn: spec [

	spec
		package: 'Cosmos-API-Tests'
			with: [ spec requires: #('Cosmos-API-Core' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-Data-API-Tests'
			with: [ spec requires: #('Cosmos-Data-API-Core' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-Commands-API-Tests'
			with:
				[ spec requires: #('Cosmos-Commands-API-Core' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-Actions-API-Tests'
			with:
				[ spec requires: #('Cosmos-Actions-API-Core' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-API-Triggers-Tests'
			with: [ spec requires: #('Cosmos-API-Triggers' 'Cosmos-UserStoryTests') ]
]

{ #category : #'private-baselines' }
BaselineOfCosmos >> describeModelDependenciesOn: spec [

	spec
		package: 'Cosmos-Data-Core'
			with: [ spec requires: #('Kepler') ];
		package: 'Cosmos-Triggers-Core'
			with: [ spec requires: #('Kepler') ];
		package: 'Cosmos-Commands-Core'
			with: [ spec requires: #('Kepler') ];
		package: 'Cosmos-Actions-Core' with: [ spec requires: #('Kepler') ];
		package: 'Cosmos-PeriodicalScheduler-Core';
		package: 'Cosmos-ActionEvaluator-Core'
]

{ #category : #baselines }
BaselineOfCosmos >> describeModelTestsDependenciesOn: spec [

	spec
		package: 'Cosmos-Tests';
		package: 'Cosmos-UserStoryTests'
			with: [ spec
				requires: #('Cosmos-Data-Core' 'Cosmos-Commands-Core' 'Cosmos-Triggers-Core') ];
		package: 'Cosmos-Data-Tests'
			with: [ spec
				requires: #('Cosmos-Tests' 'Cosmos-Data-Core' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-Triggers-Tests'
			with: [ spec
				requires: #('Cosmos-Tests' 'Cosmos-Triggers-Core' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-Commands-Tests'
			with: [ spec
				requires: #('Cosmos-Tests' 'Cosmos-Commands-Core' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-Actions-Tests'
			with: [ spec
				requires: #('Cosmos-Tests' 'Cosmos-Actions-Core' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-PeriodicalScheduler-Tests'
			with: [ spec requires: #('Cosmos-PeriodicalScheduler-Core') ];
		package: 'Cosmos-ActionEvaluator-Tests'
			with: [ spec requires: #('Cosmos-ActionEvaluator-Core') ]
]

{ #category : #actions }
BaselineOfCosmos >> postload: aLoader package: aPackageSpec [

	self registerSystemInterfaces
]

{ #category : #actions }
BaselineOfCosmos >> registerActionManagementSystemInterface [

	self
		registerInterfaceAs: #ActionManagementSystemInterface
		named: 'Action Management System Interface'
		declaring: #(#registerNamed:toEvaluate: #deregisterNamed: actions)
]

{ #category : #actions }
BaselineOfCosmos >> registerCommandManagementSystemInterface [

	self
		registerInterfaceAs: #CommandManagementSystemInterface
		named: 'Command Management System Interface'
		declaring: #(#enqueue:with: #dequeue #prioritizedCommands)
]

{ #category : #actions }
BaselineOfCosmos >> registerDataManagementSystemInterface [

	self
		registerInterfaceAs: #DataManagementSystemInterface
		named: 'Data Management System Interface'
		declaring: #(#registerStreamNamed: #register:toStreamNamed: #streamNamed:ifFound:ifNone: #streams)
]

{ #category : #actions }
BaselineOfCosmos >> registerInterfaceAs: aKey named: aName declaring: aSelectorSet [

	SystemInterface
		bind: aKey
		to: (Interface named: aName declaring: aSelectorSet) 
]

{ #category : #actions }
BaselineOfCosmos >> registerSystemInterfaces [

	self
		registerDataManagementSystemInterface;
		registerCommandManagementSystemInterface;
		registerTriggerManagementSystemInterface;
		registerActionManagementSystemInterface

]

{ #category : #actions }
BaselineOfCosmos >> registerTriggerManagementSystemInterface [

	self
		registerInterfaceAs: #TriggerManagementSystemInterface
		named: 'Trigger Management System Interface'
		declaring: #(#registerNamed:triggering:afterDataPointWasRegisteredOn:ifSatisfies: #registerNamed:triggering:periodicallyEvery:ifSatisfies: #deregisterNamed: #havePassed: #dataPointRegisteredOn: #triggers)
]

{ #category : #'private-baselines' }
BaselineOfCosmos >> setUpDependencies: spec [

	spec
		baseline: 'Kepler'
		with: [ spec
				repository: 'github://ba-st/Kepler:master/source';
				loads: #('Development') ].
	
	spec
		configuration: 'Teapot'
		with: [ spec
				versionString: #stable;
				repository: 'http://smalltalkhub.com/mc/zeroflag/Teapot/main/' ].
			
	spec
		configuration: 'Roassal2'
    		with: [  spec
				versionString: #development;
				repository: 'http://smalltalkhub.com/mc/ObjectProfile/Roassal2/main' ]
]
