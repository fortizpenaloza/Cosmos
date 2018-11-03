Class {
	#name : #BaselineOfCosmos,
	#superclass : #BaselineOf,
	#category : #BaselineOfCosmos
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
				package: 'Cosmos-CommandLineHandler'
				with: [ spec requires: #('ApplicationStarter' 'Cosmos-Model' 'Cosmos-API-Model') ].

			spec
				package: 'Cosmos-CommandLineHandler-Tests'
				with: [ spec requires: #('Cosmos-CommandLineHandler') ].

			spec package: 'Cosmos-Tools' with: [ spec requires: #('Roassal2') ].

			spec
				group: 'Deployment'
					with: #('Cosmos-Model' 'Cosmos-API-Model' 'Cosmos-CommandLineHandler');
				group: 'Tests'
					with:
					#('Cosmos-Model-Tests' 'Cosmos-API-Model-Tests' 'Cosmos-CommandLineHandler-Tests' 'Cosmos-Code-Quality-Tests');
				group: 'Tools' with: #('Cosmos-Tools');
				group: 'CI' with: #('Deployment' 'Tests');
				group: 'Development' with: #('CI' 'Tools');
				group: 'default' with: #('Deployment').
			spec postLoadDoIt: #postload:package: ]
]

{ #category : #baselines }
BaselineOfCosmos >> describeAPIDependenciesOn: spec [

	spec
		package: 'Cosmos-API-Common' with: [ spec requires: #('Stargate') ];
		package: 'Cosmos-API-Data' with: [ spec requires: #('Cosmos-API-Common' 'Cosmos-Data') ];
		package: 'Cosmos-API-Commands' with: [ spec requires: #('Cosmos-API-Common' 'Cosmos-Commands') ];
		package: 'Cosmos-API-Actions' with: [ spec requires: #('Cosmos-API-Common' 'Cosmos-Actions') ];
		package: 'Cosmos-API-Triggers' with: [ spec requires: #('Cosmos-API-Common' 'Cosmos-Triggers') ].
	
	spec
		group: 'Cosmos-API-Model'
		with: #('Cosmos-API-Common' 'Cosmos-API-Data' 'Cosmos-API-Commands' 'Cosmos-API-Actions' 'Cosmos-API-Triggers')
]

{ #category : #baselines }
BaselineOfCosmos >> describeAPITestsDependenciesOn: spec [

	spec
		package: 'Cosmos-API-Common-Tests' with: [ spec requires: #('Cosmos-API-Common' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-API-Data-Tests' with: [ spec requires: #('Cosmos-API-Data' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-API-Commands-Tests' with: [ spec requires: #('Cosmos-API-Commands' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-API-Actions-Tests' with: [ spec requires: #('Cosmos-API-Actions' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-API-Triggers-Tests' with: [ spec requires: #('Cosmos-API-Triggers' 'Cosmos-UserStoryTests') ].

	spec
		group: 'Cosmos-API-Model-Tests'
		with: #('Cosmos-API-Common-Tests' 'Cosmos-API-Data-Tests' 'Cosmos-API-Commands-Tests' 'Cosmos-API-Actions-Tests' 'Cosmos-API-Triggers-Tests')
]

{ #category : #baselines }
BaselineOfCosmos >> describeModelDependenciesOn: spec [

	spec
		package: 'Cosmos-Identifier' with: [ spec requires: #('Kepler') ];
		package: 'Cosmos-Metadata' with: [ spec requires: #('Kepler') ];
		package: 'Cosmos-Data' with: [ spec requires: #('Kepler') ];
		package: 'Cosmos-Metadata' with: [ spec requires: #('Kepler') ];
		package: 'Cosmos-Triggers' with: [ spec requires: #('Kepler') ];
		package: 'Cosmos-Commands' with: [ spec requires: #('Kepler') ];
		package: 'Cosmos-Actions' with: [ spec requires: #('Kepler') ];
		package: 'Cosmos-PeriodicalScheduler-Core';
		package: 'Cosmos-ActionEvaluator-Core'.

	spec
		group: 'Cosmos-Model'
		with:
			#('Cosmos-Identifier' 'Cosmos-Metadata' 'Cosmos-Data' 'Cosmos-Triggers' 'Cosmos-Commands' 'Cosmos-Actions' 'Cosmos-PeriodicalScheduler-Core' 'Cosmos-ActionEvaluator-Core')
]

{ #category : #baselines }
BaselineOfCosmos >> describeModelTestsDependenciesOn: spec [

	spec
		package: 'Cosmos-Tests';
		package: 'Cosmos-UserStoryTests'
			with: [ spec requires: #('Cosmos-Data' 'Cosmos-Commands' 'Cosmos-Triggers' 'Stargate-Tests') ];
		package: 'Cosmos-Identifier-Tests'
			with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Identifier') ];
		package: 'Cosmos-Metadata-Tests'
			with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Metadata') ];
		package: 'Cosmos-Data-Tests'
			with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Data' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-Triggers-Tests'
			with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Triggers' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-Commands-Tests'
			with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Commands' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-Actions-Tests'
			with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Actions' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-PeriodicalScheduler-Tests'
			with: [ spec requires: #('Cosmos-PeriodicalScheduler-Core') ];
		package: 'Cosmos-ActionEvaluator-Tests'
			with: [ spec requires: #('Cosmos-ActionEvaluator-Core') ].

	spec
		group: 'Cosmos-Model-Tests'
		with:
			#('Cosmos-Tests' 'Cosmos-UserStoryTests' 'Cosmos-Identifier-Tests' 'Cosmos-Metadata-Tests' 'Cosmos-Data-Tests' 'Cosmos-Triggers-Tests' 'Cosmos-Commands-Tests' 'Cosmos-Actions-Tests' 'Cosmos-PeriodicalScheduler-Tests' 'Cosmos-ActionEvaluator-Tests')
]

{ #category : #actions }
BaselineOfCosmos >> postload: aLoader package: aPackageSpec [

	self registerSystemInterfaces
]

{ #category : #'registering interfaces' }
BaselineOfCosmos >> registerActionManagementSystemInterface [

	self
		registerInterfaceAs: #ActionManagementSystemInterface
		named: 'Action Management System Interface'
		declaring: #(#register: #deregister: actions)
]

{ #category : #'registering interfaces' }
BaselineOfCosmos >> registerCommandManagementSystemInterface [

	self
		registerInterfaceAs: #CommandManagementSystemInterface
		named: 'Command Management System Interface'
		declaring: #(#register: #deregister: #dequeueCommand #commands)
]

{ #category : #'registering interfaces' }
BaselineOfCosmos >> registerDataManagementSystemInterface [

	self
		registerInterfaceAs: #DataManagementSystemInterface
		named: 'Data Management System Interface'
		declaring: #(#register: #deregister: #register:toStreamNamed:  #streamIdentifiedBy: #streams)
]

{ #category : #'registering interfaces' }
BaselineOfCosmos >> registerIdentifierSystemInterface [

	self
		registerInterfaceAs: #IdentifierSystemInterface
		named: 'Identifier System Interface'
		declaring: #(#next)
]

{ #category : #'registering interfaces' }
BaselineOfCosmos >> registerInterfaceAs: aKey named: aName declaring: aSelectorSet [

	SystemInterface
		bind: aKey
		to: (Interface named: aName declaring: aSelectorSet) 
]

{ #category : #'registering interfaces' }
BaselineOfCosmos >> registerMetadataSystemInterface [

	self
		registerInterfaceAs: #MetadataSystemInterface
		named: 'Metadata System Interface'
		declaring: #(#metadataFor: #register: #describedObjectBy:as:ifNone:)
]

{ #category : #'registering interfaces' }
BaselineOfCosmos >> registerSystemInterfaces [

	self
		registerIdentifierSystemInterface;
		registerDataManagementSystemInterface;
		registerMetadataSystemInterface;
		registerCommandManagementSystemInterface;
		registerTriggerManagementSystemInterface;
		registerActionManagementSystemInterface
]

{ #category : #'registering interfaces' }
BaselineOfCosmos >> registerTriggerManagementSystemInterface [

	self
		registerInterfaceAs: #TriggerManagementSystemInterface
		named: 'Trigger Management System Interface'
		declaring: #(#register: #deregisterNamed: #havePassed: #dataPointRegisteredOn: #triggers)
]

{ #category : #dependencies }
BaselineOfCosmos >> setUpDependencies: spec [

	spec
		baseline: 'Kepler'
		with: [ spec
				repository: 'github://ba-st/Kepler:v2.0.2/source';
				loads: #('Deployment' 'SystemBasedTests') ].

	spec
		baseline: 'Stargate'
			with: [ spec
				repository: 'github://ba-st/stargate:v0.1.1/source';
				loads: 'Deployment' ];
		project: 'Stargate-Tests' copyFrom: 'Stargate' with: [ spec loads: 'Development' ].

	spec
		baseline: 'ApplicationStarter'
			with: [ spec
				repository: 'github://ba-st/ApplicationStarter:v1.0.0/source';
				loads: 'Deployment' ];
		import: 'ApplicationStarter'.

	spec
		configuration: 'Roassal2'
		with: [ spec
				versionString: #stable;
				repository: 'http://smalltalkhub.com/mc/ObjectProfile/Roassal2/main' ]
]
