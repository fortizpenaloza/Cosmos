test
testQueryFeedByIdentifierDoesntExistsFails

	| dataChannel |

	dataChannel := self dataManagementSystem registerChannelNamed: 'Channel #1'.

	self
		should: [ self dataManagementSystem channeldentifiedBy: 2 ]
		raise: ObjectNotFoundInSystem
		withDescription: 'Feed does not exists in system.'