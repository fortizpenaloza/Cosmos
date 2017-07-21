tests
testQueryingSnapshotOfChannelNotValid

	| interface |

	interface := RESTDataInterface workingWith: rootSystem.

	self
		should: [ interface currentSnapshotOfChannelIdentifiedBy: '2' ]
		raise: HTTPClientError