baselines
baseline: spec
	<baseline>
	
	spec
		for: #common
		do:  [ 		
			spec configuration: 'Chalten' with: [
				spec
					loads: #('Core');
					repository: 'github://mtaborda/chalten:v5.0.0/repository'].
				
			spec configuration: 'ZincHTTPComponents' with: [ 
				spec
					loads: #('REST' 'WebSocket');
					versionString: #'stable';
					repository: 'http://mc.stfx.eu/ZincHTTPComponets' ].
				
			spec
				package: 'IoT-Core' with: [ spec requires: #('Chalten' 'ZincHTTPComponents') ];
				package: 'IoT-Tests' with: [ spec requires: 'IoT-Core' ].
			spec
				group: 'Development' with: #('IoT-Core' 'IoT-Tests');
				group: 'Deployment' with: #('IoT-Core');
				group: 'default' with: #('Deployment') ]
