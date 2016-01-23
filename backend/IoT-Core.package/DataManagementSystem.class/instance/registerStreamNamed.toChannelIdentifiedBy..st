managing
registerStreamNamed: aName toChannelIdentifiedBy: anIdentifier

	^ self
		channelIdentifiedBy: anIdentifier
		ifFound: [ :dataChannel |  | dataStream |

			dataStream := DataStream
				named: aName
				createdOn: timeSystem dateTime
				belongingTo: dataChannel.
				
			self registerStream: dataStream.
			
			dataStream ]
		ifNone: [ ObjectNotFoundInSystem signal: 'Data channel does not exists in system' ]