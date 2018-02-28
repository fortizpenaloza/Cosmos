installing
installAPIsOn: system

	| server |

	server := self teapot.

	(DataAPIInstaller toWorkWith: system on: server) install.
	(TriggersAPIInstaller toWorkWith: system on: server) install.
	(ActionsAPIInstaller toWorkWith: system on: server) install.

	server
		exception:
			HTTPClientError
				-> [ :signal :request | 
					(ZnResponse statusCode: signal tag)
						entity: (ZnEntity json: signal messageText);
						yourself ].
					
	server start