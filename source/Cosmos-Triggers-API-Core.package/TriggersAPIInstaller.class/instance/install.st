initialization
install

	| interface |

	interface := TriggersAPI workingWith: (TriggersAPIContext workingWith: rootSystem).

	server
		GET: '/triggers' -> [ :request | interface triggers ];
		POST: '/triggers' -> [ :request | interface registerFrom: request contents ];
		output: #text;
		DELETE:
			'/triggers/<name>'
				->
					[ :request | interface deregisterNamed: ((request at: #name) replaceAll: $_ with: Character space) ];
		output: #text