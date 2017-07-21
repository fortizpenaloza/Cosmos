running
setUp

	| interface |

	super setUp.
	(SensorsSampleAddOn on: rootSystem) install.

	interface := RESTDataInterface workingWith: rootSystem.

	server := Teapot
		configure:
			{(#port -> 8010).
			(#debugMode -> true)}.
	server
		GET: '/data-streams' -> [ :request | interface streams ];
		GET:
			'/data-streams/<name>'
				-> [ :request | interface streamNamed: (request at: #name) ];
		start