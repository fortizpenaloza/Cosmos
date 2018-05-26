private-baselines
describeAPIDependeciesOn: spec

	spec
		package: 'Cosmos-API-Core' with: [ spec requires: 'Teapot' ];
		package: 'Cosmos-Data-API-Core'
			with: [ spec requires: #('Cosmos-API-Core' 'Cosmos-Data-Core') ];
		package: 'Cosmos-Commands-API-Core'
			with: [ spec requires: #('Cosmos-API-Core' 'Cosmos-Commands-Core') ];
		package: 'Cosmos-Actions-API-Core'
			with: [ spec requires: #('Cosmos-API-Core' 'Cosmos-Actions-Core') ];
		package: 'Cosmos-Triggers-API-Core'
			with: [ spec requires: #('Cosmos-API-Core' 'Cosmos-Triggers-Core') ]