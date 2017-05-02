baselines
baseline: spec

	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'Chalten'
				with: [ spec
						repository: 'github://mtaborda/chalten:v5.0.0/repository';
						loads: #('Core') ].

			spec
				configuration: 'Teapot'
				with: [ spec
						versionString: #stable;
						repository: 'http://smalltalkhub.com/mc/zeroflag/Teapot/main/' ].

			spec
				configuration: 'ZincHTTPComponents'
				with: [ spec
						loads: #('REST' 'WebSocket');
						versionString: #stable;
						repository: 'http://mc.stfx.eu/ZincHTTPComponets' ].

			spec
				package: 'IoT-Core' with: [ spec requires: #('Chalten' 'ZincHTTPComponents') ];
				package: 'IoT-Notifications-Core' with: [ spec requires: 'IoT-Core' ];
				package: 'IoT-Data-Core' with: [ spec requires: #('IoT-Core' 'IoT-Notifications-Core') ];
				package: 'IoT-ConditionalTrigger-Core' with: [ spec requires: #('IoT-Core' 'IoT-Notifications-Core') ];
				package: 'IoT-Commands-Core' with: [ spec requires: 'IoT-Core' ];
				package: 'IoT-REST-API' with: [ spec requires: 'Teapot' ];
				package: 'IoT-Tests' with: [ spec requires: 'IoT-Core' ];
				package: 'IoT-Notifications-Tests' with: [ spec requires: 'IoT-Notifications-Core' ];
				package: 'IoT-Data-Tests' with: [ spec requires: 'IoT-Data-Core' ];
				package: 'IoT-ConditionalTrigger-Tests' with: [ spec requires: 'IoT-ConditionalTrigger-Core' ];
				package: 'IoT-Commands-Tests' with: [ spec requires: 'IoT-Commands-Core' ];
				package: 'IoT-REST-API-Tests' with: [ spec requires: 'IoT-REST-API' ].
			spec
				group: 'Deployment'
					with: #('IoT-Core' 'IoT-Notifications-Core' 'IoT-Data-Core' 'IoT-ConditionalTrigger-Core' 'IoT-Commands-Core' 'IoT-REST-API');
				group: 'Tests' with: #('IoT-Tests' 'IoT-Notifications-Tests' 'IoT-Data-Tests'  'IoT-ConditionalTrigger-Tests' 'IoT-Commands-Tests'  'IoT-REST-API-Tests' );
				group: 'Development' with: #('Deployment' 'Tests');
				group: 'default' with: #('Deployment') ]