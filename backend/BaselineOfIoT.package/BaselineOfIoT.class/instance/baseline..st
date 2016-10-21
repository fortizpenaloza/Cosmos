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
				package: 'IoT-Notifications-Core' with: [ spec requires: 'IoT-Core' ];
				package: 'IoT-REST-API' with: [ spec requires: 'Teapot' ];
				package: 'IoT-Tests' with: [ spec requires: 'IoT-Core' ];
				package: 'IoT-Notifications-Tests' with: [ spec requires: 'IoT-Notifications-Core' ];
				package: 'IoT-REST-API-Tests' with: [ spec requires: 'IoT-REST-API' ].
			spec
				group: 'Deployment' with: #('IoT-Core' 'IoT-REST-API' 'IoT-Notifications-Core');
				group: 'Tests' with: #('IoT-Tests' 'IoT-REST-API-Tests' 'IoT-Notifications-Tests');	
				group: 'Development' with: #('Deployment' 'Tests');			
				group: 'default' with: #('Deployment') ]
