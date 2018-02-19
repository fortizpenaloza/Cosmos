installing
teapot

	^ Teapot
		configure:
			{(#defaultOutput -> #json).
			(#port -> 8080).
			(#debugMode -> true)}