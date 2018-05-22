installing
install

	| interface |

	interface := DataAPI workingWith: system.

	server
		GET: '/data-streams' -> [ :request | interface streams ];
		GET: '/data-streams/<name>' -> [ :request | interface streamNamed: (request at: #name) ];
		GET:
			'/data-streams/<name>?<query-string>'
				->
					[ :request | interface streamNamed: (request at: #name) filteredBy: (request at: #'query-string') ];
		POST: '/data-streams' -> [ :request | interface registerStreamFrom: request contents ];
		output: #text;
		POST: '/data-points' -> [ :request | interface registerBulkPointsFrom: request contents ];
		output: #text