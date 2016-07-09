as yet unclassified
streamsOfChannel: aDataChannel 
	^dataStreams select:[:dataStream| dataStream dataChannel = aDataChannel]