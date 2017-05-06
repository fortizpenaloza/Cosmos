formatting
format: aTimeOfDay

	| stream |

	stream := WriteStream on: String new.
	self
		putHoursOf: aTimeOfDay on: stream;
		putSeparatorOn: stream;
		putMinutesOf: aTimeOfDay on: stream;
		putSeparatorOn: stream;
		putSecondsOf: aTimeOfDay on: stream.
	^ stream contents