installing
installDataAPIOn: system

	| server |

	server := self teapot.
	(DataAPIInstaller toWorkWith: system on: server) install.
	server start