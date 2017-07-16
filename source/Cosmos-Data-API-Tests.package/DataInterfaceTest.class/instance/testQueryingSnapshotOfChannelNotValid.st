tests
testQueryingSnapshotOfChannelNotValid

	| interface |

	interface := DataInterface workingWith: rootSystem.

	self
		should: [ interface currentSnapshotOfChannelIdentifiedBy: '2' ]
		raise: HTTPClientError