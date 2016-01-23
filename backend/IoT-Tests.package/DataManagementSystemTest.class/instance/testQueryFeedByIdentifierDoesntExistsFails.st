test
testQueryFeedByIdentifierDoesntExistsFails

	| dataChannel |

	dataChannel := self dataManagementSystem registerChannelNamed: 'Channel #1'.

	self
		should: [ self dataManagementSystem channelIdentifiedBy: 2 ]
		raise: ObjectNotFoundInSystem
		withDescription: 'Feed does not exists in system.'