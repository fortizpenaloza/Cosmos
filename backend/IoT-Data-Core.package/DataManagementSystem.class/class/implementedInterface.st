system specification
implementedInterface

	^ SystemInterface
		named: 'Data Management System Interface'
		offering:
			(OrderedCollection new
				add: #registerChannelNamed:;
				add: #registerStreamNamed:toChannelIdentifiedBy:;
				add: #register:toStreamNamed:ofChannelIdentifiedBy:;
				add: #channelIdentifiedBy:ifFound:ifNone:;
				add: #streamNamed:ofChannelIdentifiedBy:ifFound:ifNone:;
				add: #streamsOf:;
				yourself)