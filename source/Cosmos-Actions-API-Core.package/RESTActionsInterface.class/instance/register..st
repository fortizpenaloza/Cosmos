API
register: aJSON

	| rawAction |

	rawAction := (NeoJSONReader on: aJSON readStream)
		propertyNamesAsSymbols: true;
		next.

	^ self actionManagementSystem
		registerNamed: (context parseNameFrom: rawAction)
		toEvaluate: (context parseRequestFrom: rawAction)