formatting
format: aDate

	| stream |

	stream := WriteStream on: String new.
	self
		putYearOf: aDate on: stream;
		putSeparatorOn: stream;
		putMonthOf: aDate on: stream;
		putSeparatorOn: stream;
		putDayOf: aDate on: stream.
	^ stream contents