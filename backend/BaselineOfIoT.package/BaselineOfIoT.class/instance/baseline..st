baselines
baseline: spec
	<baseline>
	
	spec
		for: #common
		do:  [ 		
			spec baseline: 'Chalten' with: [
				spec
					repository: 'github://mtaborda/chalten:v5.0.0/repository';
					loads: #('Core')].
				
			spec configuration: 'Teapot' with: [ 
				spec
					versionString: #'stable';
					repository: 'http://smalltalkhub.com/mc/zeroflag/Teapot/main/' ].
								
			spec configuration: 'ZincHTTPComponents' with: [ 
				spec
					loads: #('REST' 'WebSocket');
					versionString: #'stable';
					repository: 'http://mc.stfx.eu/ZincHTTPComponets' ].
				
			spec
				package: 'IoT-Core' with: [ spec requires: #('Chalten' 'ZincHTTPComponents') ];
				package: 'IoT-ApiRest' with: [ spec requires: 'Teapot' ];
				package: 'IoT-Tests' with: [ spec requires: 'IoT-Core' ];
				package: 'IoT-ApiRest-Tests' with: [ spec requires: 'IoT-ApiRest' ].
			spec
				group: 'Development' with: #('IoT-Core' 'IoT-ApiRest' 'IoT-Tests' 'IoT-ApiRest-Tests');
				group: 'Deployment' with: #('IoT-Core' 'IoT-ApiRest');
				group: 'default' with: #('Deployment') ]
