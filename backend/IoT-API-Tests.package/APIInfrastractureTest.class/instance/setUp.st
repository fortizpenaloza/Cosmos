running
setUp

	| interface |

	super setUp.

	interface := DataInterface workingWith: rootSystem.

	server := Teapot
		configure:
			{(#port -> 8010).
			(#debugMode -> true)}.
	server
		GET:
			'/data-channel/<identifier>'
				-> [ :request | interface currentSnapshotOfChannelIdentifiedBy: (request at: #identifier) asNumber ];
		GET:
			'/data-channel/<identifier>/data-stream/<name>'
				-> [ :request | interface streamNamed: (request at: #name) ofChannelIdentifiedBy: (request at: #identifier) asNumber ];
		start