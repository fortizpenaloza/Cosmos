actions
defineDataManagementSystemInterface

	Smalltalk
		at: #DataManagementSystemInterface
		put:
			(SystemInterface
				named: 'Data Management System Interface'
				offering:
					#(#registerChannelNamed: #registerStreamNamed:toChannelIdentifiedBy: #register:toStreamNamed:ofChannelIdentifiedBy: #channelIdentifiedBy:ifFound:ifNone: #streamNamed:ofChannelIdentifiedBy:ifFound:ifNone: #streamsOf:))