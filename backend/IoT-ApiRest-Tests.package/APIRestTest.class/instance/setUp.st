as yet unclassified
setUp

	| timeSource |

	timeSource := FixedTimeSource on: self septemberSixth2015AtNoon.
	identifierProvider := FixedNumberProvider providing: self identifier.
	rootSystem := CompositeSystem named: 'IoT for testing'.

	(OrderedCollection
		with: (TimeSystem using: timeSource)
		with: (DataManagementSystem using: identifierProvider)
		with: ConditionalTriggersSystem new) do: [ :subsystem | rootSystem register: subsystem ].

	rootSystem startUp