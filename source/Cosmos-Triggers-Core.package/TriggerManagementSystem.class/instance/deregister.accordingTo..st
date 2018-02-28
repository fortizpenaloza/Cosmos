private-managing
deregister: aTrigger accordingTo: aTriggeringPolicy 

	aTriggeringPolicy deregister: aTrigger from: self.
	triggers remove: aTrigger