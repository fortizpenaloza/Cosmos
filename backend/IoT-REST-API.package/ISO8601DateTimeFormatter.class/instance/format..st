formatting
format: aDateTime

	| stream |

	stream := WriteStream on: String new.
	self
		putDateOf: aDateTime on: stream;
		putDelimiterOn: stream;
		putTimeOf: aDateTime on: stream;
		putTimeZoneOf: aDateTime on: stream.
	^ stream contents