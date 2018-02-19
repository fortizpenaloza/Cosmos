installing
install

	| system |

	system := self installedSystem.
	self installDataAPIOn: system.
	^ system