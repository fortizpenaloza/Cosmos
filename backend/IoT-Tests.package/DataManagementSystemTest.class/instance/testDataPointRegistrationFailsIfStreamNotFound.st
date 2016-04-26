tests
testDataPointRegistrationFailsIfStreamNotFound

	| dataChannel |

	dataChannel := self dataManagementSystem registerChannelNamed: 'Channel #1'.

	self
		should: [ self dataManagementSystem
				register: 10
				toStreamNamed: 'Temperature'
				ofChannelIdentifiedBy: dataChannel identifier ]
		raise: ObjectNotFoundInSystem
		withDescription: 'Data stream does not exists in system'