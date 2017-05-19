running
setUp

	| dataInterface commandInterface |

	super setUp.

	dataInterface := DataInterface workingWith: rootSystem.
	commandInterface := CommandInterface workingWith: rootSystem.

	server := Teapot
		configure:
			{(#port -> 8010).
			(#debugMode -> true)}.
	server
		GET:
			'/data-channel/<identifier>'
				-> [ :request | dataInterface currentSnapshotOfChannelIdentifiedBy: (request at: #identifier) asNumber ];
		GET:
			'/data-channel/<identifier>/data-stream/<name>'
				-> [ :request | dataInterface streamNamed: (request at: #name) ofChannelIdentifiedBy: (request at: #identifier) asNumber ];
		GET:
			'/priority-queue/<queueIdentifier>/next/'
				-> [ :request | commandInterface nextCommandFromQueueIdentifiedBy: (request at: #queueIdentifier) asNumber ];
		start