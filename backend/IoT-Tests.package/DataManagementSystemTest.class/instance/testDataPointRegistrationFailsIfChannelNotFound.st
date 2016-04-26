tests
testDataPointRegistrationFailsIfChannelNotFound

	| dataChannel dataStream |

	dataChannel := self dataManagementSystem registerChannelNamed: 'Channel #1'.
	dataStream := self dataManagementSystem
		registerStreamNamed: 'Temperature'
		toChannelIdentifiedBy: dataChannel identifier.

	self
		should: [ self dataManagementSystem
				register: 10
				toStreamNamed: dataStream name
				ofChannelIdentifiedBy: 2 ]
		raise: ObjectNotFoundInSystem
		withDescription: 'Data stream does not exists in system'