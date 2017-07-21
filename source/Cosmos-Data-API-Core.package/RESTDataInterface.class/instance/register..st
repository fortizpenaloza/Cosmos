API
register: aJSON

	| rawData |

	rawData := (NeoJSONReader on: aJSON readStream) next.

	^ rawData
		collect: [ :rawDataPoint | 
			self
				register: (rawDataPoint at: 'value')
				toStreamNamed: (rawDataPoint at: 'name') ]