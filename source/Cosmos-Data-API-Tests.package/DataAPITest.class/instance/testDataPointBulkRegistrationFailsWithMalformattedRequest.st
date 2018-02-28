tests
testDataPointBulkRegistrationFailsWithMalformattedRequest

	| interface |

	interface := DataAPI workingWith: rootSystem.

	self
		should: [ interface
				registerBulkPointsFrom:
					'[
			{
				"xxx" : "Temperature",
				"value" : 24
			},
			{
				"data-stream" : "Pressure",
				"value" : 89
			}
		]' ]
		raise: HTTPClientError
		withDescription: '{"error":{"code":400,"message":"Expected key data-stream was not found"}'