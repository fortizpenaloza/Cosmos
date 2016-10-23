tests
testFormattingUsingExtendedFormat

	self
		assert: (ISO8601TimeOfDayFormatter usingExtendedFormat format: TimeOfDay firstTimeOfDay)
		equals: '00:00:00'.
	self
		assert:
			(ISO8601TimeOfDayFormatter usingExtendedFormat
				format:
					(TimeOfDay
						hours: 8
						minutes: 8
						seconds: 8
						milliseconds: 80))
		equals: '08:08:08'