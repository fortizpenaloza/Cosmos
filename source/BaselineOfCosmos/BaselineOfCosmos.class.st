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

			spec package: 'Cosmos-CommandLineHandler' with: [ spec requires: #('Teapot' 'Kepler' 'Cosmos-API-Data') ].

			spec package: 'Cosmos-Tools' with: [ spec requires: #('Roassal2') ].

			spec
				group: 'Deployment' with: #('Cosmos-Model' 'Cosmos-API-Model' 'Cosmos-CommandLineHandler');
				group: 'Tests' with: #('Cosmos-Model-Tests' 'Cosmos-API-Model-Tests' 'Cosmos-Code-Quality-Tests');
				group: 'Tools' with: #('Cosmos-Tools');
				group: 'CI' with: #('Deployment' 'Tests');
				group: 'Development' with: #('CI' 'Tools');
				group: 'default' with: #('Deployment').
			spec postLoadDoIt: #postload:package: ]
]

{ #category : #'private-baselines' }
BaselineOfCosmos >> describeAPIDependenciesOn: spec [

	spec
		package: 'Cosmos-API' with: [ spec requires: 'Teapot' ];
		package: 'Cosmos-API-Data' with: [ spec requires: #('Cosmos-API' 'Cosmos-Data') ];
		package: 'Cosmos-API-Commands' with: [ spec requires: #('Cosmos-API' 'Cosmos-Commands') ];
		package: 'Cosmos-API-Actions' with: [ spec requires: #('Cosmos-API' 'Cosmos-Actions') ];
		package: 'Cosmos-API-Triggers' with: [ spec requires: #('Cosmos-API' 'Cosmos-Triggers') ].
	
	spec
		group: 'Cosmos-API-Model'
		with: #('Cosmos-API' 'Cosmos-API-Data' 'Cosmos-API-Commands' 'Cosmos-API-Actions' 'Cosmos-API-Triggers')
]

{ #category : #'private-baselines' }
BaselineOfCosmos >> describeAPITestsDependenciesOn: spec [

	spec
		package: 'Cosmos-API-Tests' with: [ spec requires: #('Cosmos-API' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-API-Data-Tests' with: [ spec requires: #('Cosmos-API-Data' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-API-Commands-Tests' with: [ spec requires: #('Cosmos-API-Commands' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-API-Actions-Tests' with: [ spec requires: #('Cosmos-API-Actions' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-API-Triggers-Tests' with: [ spec requires: #('Cosmos-API-Triggers' 'Cosmos-UserStoryTests') ].

	spec
		group: 'Cosmos-API-Model-Tests'
		with: #('Cosmos-API-Tests' 'Cosmos-API-Data-Tests' 'Cosmos-API-Commands-Tests' 'Cosmos-API-Actions-Tests' 'Cosmos-API-Triggers-Tests')
]

{ #category : #'private-baselines' }
BaselineOfCosmos >> describeModelDependenciesOn: spec [

	spec
		package: 'Cosmos-Data' with: [ spec requires: #('Kepler') ];
		package: 'Cosmos-Triggers' with: [ spec requires: #('Kepler') ];
		package: 'Cosmos-Commands' with: [ spec requires: #('Kepler') ];
		package: 'Cosmos-Actions' with: [ spec requires: #('Kepler') ];
		package: 'Cosmos-PeriodicalScheduler-Core';
		package: 'Cosmos-ActionEvaluator-Core'.

	spec
		group: 'Cosmos-Model'
		with:
			#('Cosmos-Data' 'Cosmos-Triggers' 'Cosmos-Commands' 'Cosmos-Actions' 'Cosmos-PeriodicalScheduler-Core' 'Cosmos-ActionEvaluator-Core')
]

{ #category : #'private-baselines' }
BaselineOfCosmos >> describeModelTestsDependenciesOn: spec [

	spec
		package: 'Cosmos-Tests';
		package: 'Cosmos-UserStoryTests' with: [ spec requires: #('Cosmos-Data' 'Cosmos-Commands' 'Cosmos-Triggers') ];
		package: 'Cosmos-Data-Tests' with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Data' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-Triggers-Tests' with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Triggers' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-Commands-Tests' with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Commands' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-Actions-Tests' with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Actions' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-PeriodicalScheduler-Tests' with: [ spec requires: #('Cosmos-PeriodicalScheduler-Core') ];
		package: 'Cosmos-ActionEvaluator-Tests' with: [ spec requires: #('Cosmos-ActionEvaluator-Core') ].
		
	spec
		group: 'Cosmos-Model-Tests'
		with: #('Cosmos-Tests' 'Cosmos-UserStoryTests' 'Cosmos-Data-Tests' 'Cosmos-Triggers-Tests' 'Cosmos-Commands-Tests' 'Cosmos-Actions-Tests' 'Cosmos-PeriodicalScheduler-Tests' 'Cosmos-ActionEvaluator-Tests')
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
