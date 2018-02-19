installing
install

	| interface |

	interface := RESTDataInterface workingWith: system.

	server
		GET: '/data-streams' -> [ :request | interface streams ];
		GET:
			'/data-streams/<name>'
				-> [ :request | interface streamNamed: (request at: #name) ];
		POST:
			'/data-streams'
				-> [ :request | interface registerStreamFrom: request contents ];
		output: #text;
		POST: '/data-points' -> [ :request | interface registerBulkPointsFrom: request contents ];
		output: #text;
		exception: HTTPClientError -> [ :signal :request | TeaResponse code: signal tag ]