tests
testInstallation

	| system teapot |

	teapot := Teapot on.

	system := nil.

	(DataAPIInstaller toWorkWith: system on: teapot) install.

	self assert: teapot routes size equals: 4