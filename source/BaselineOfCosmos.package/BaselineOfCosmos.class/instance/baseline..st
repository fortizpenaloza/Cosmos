baselines
baseline: spec

	<baseline>
	spec
		for: #common
		do: [ self setUpDependencies: spec.
			spec
				package: 'Cosmos-Core' with: [ spec requires: #('Buoy' 'Chalten' 'ZincHTTPComponents') ];
				package: 'Cosmos-Data-Core' with: [ spec requires: #('Cosmos-Core' 'Kepler') ];
				package: 'Cosmos-ConditionalTrigger-Core' with: [ spec requires: #('Cosmos-Core' 'Kepler') ];
				package: 'Cosmos-Commands-Core' with: [ spec requires: 'Cosmos-Core' ];
				package: 'Cosmos-Actions-Core' with: [ spec requires: #('Cosmos-Core' 'Kepler') ].
		
			spec
				package: 'Cosmos-API-Core' with: [ spec requires: 'Teapot' ];
				package: 'Cosmos-Data-API-Core' with: [ spec requires: #('Cosmos-API-Core' 'Cosmos-Data-Core') ];
				package: 'Cosmos-Commands-API-Core' with: [ spec requires: #('Cosmos-API-Core' 'Cosmos-Commands-Core') ].
		
			spec
				package: 'Cosmos-Tests' with: [ spec requires: 'Cosmos-Core' ];
				package: 'Cosmos-UserStoryTests' with: [ spec requires: #('Cosmos-Data-Core' 'Cosmos-Commands-Core' 'Cosmos-ConditionalTrigger-Core') ];
				package: 'Cosmos-Data-Tests' with: [ spec requires: 'Cosmos-UserStoryTests' ];
				package: 'Cosmos-ConditionalTrigger-Tests' with: [ spec requires: #('Cosmos-ConditionalTrigger-Core' 'Cosmos-UserStoryTests') ];
				package: 'Cosmos-Commands-Tests' with: [ spec requires: #('Cosmos-Commands-Core' 'Cosmos-UserStoryTests') ];
				package: 'Cosmos-Actions-Tests' with: [spec requires: #('Cosmos-Actions-Core' 'Cosmos-UserStoryTests')].
				
			spec
				package: 'Cosmos-API-Tests' with: [ spec requires: #('Cosmos-API-Core' 'Cosmos-UserStoryTests') ];
				package: 'Cosmos-Data-API-Tests' with: [ spec requires: #('Cosmos-Data-API-Core' 'Cosmos-UserStoryTests') ];
				package: 'Cosmos-Commands-API-Tests' with: [ spec requires: #('Cosmos-Commands-API-Core' 'Cosmos-UserStoryTests') ];
				package: 'Cosmos-Code-Quality-Tests'.
			spec
				group: 'Deployment'
					with:
					#('Cosmos-Core' 'Cosmos-Data-Core' 'Cosmos-ConditionalTrigger-Core' 'Cosmos-Commands-Core' 'Cosmos-Actions-Core' 'Cosmos-API-Core' 'Cosmos-Data-API-Core' 'Cosmos-Commands-API-Core');
				group: 'Tests'
					with:
					#('Cosmos-Tests' 'Cosmos-UserStoryTests' 'Cosmos-Data-Tests' 'Cosmos-ConditionalTrigger-Tests' 'Cosmos-Commands-Tests' 'Cosmos-Actions-Tests' 'Cosmos-API-Tests' 'Cosmos-Data-API-Tests' 'Cosmos-Commands-API-Tests' 'Cosmos-Code-Quality-Tests');
				group: 'Development' with: #('Deployment' 'Tests');
				group: 'default' with: #('Deployment').
			spec postLoadDoIt: #postload:package:.
			spec preLoadDoIt: #preload:package: ]