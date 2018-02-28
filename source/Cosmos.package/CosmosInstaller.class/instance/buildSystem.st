installing
buildSystem

	| builder system |

	builder := CompositeSystemBuilder new.
	builder
		add: (TimeSystem using: SystemTimeSource new);
		add: EventNotificationSystem new;
		add: DataManagementSystem new;
		add: TriggerManagementSystem new;
		add: ActionManagementSystem new;
		add: CommandManagementSystem new;
		yourself.

	system := builder build.
	^ system