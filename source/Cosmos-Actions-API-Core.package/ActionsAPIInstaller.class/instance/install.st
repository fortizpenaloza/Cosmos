installing
install

	| interface |

	interface := ActionsAPI workingWith: (ActionsAPIContext workingWith: rootSystem).

	server
		GET: '/actions' -> [ :request | interface actions ];
		POST: '/actions' -> [ :request | interface registerFrom: request contents ];
		DELETE:
			'/actions/<name>' -> [ :request | interface deregisterNamed: (request at: #name) ];
		output: #text