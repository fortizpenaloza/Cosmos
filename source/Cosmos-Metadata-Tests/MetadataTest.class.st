Class {
	#name : #MetadataTest,
	#superclass : #TestCase,
	#category : #'Cosmos-Metadata-Tests'
}

{ #category : #accessing }
MetadataTest >> temperatureStream [

	^ DataStream named: 'Temperature'
]

{ #category : #tests }
MetadataTest >> testHash [

	| metadata equivalentMetadata differentMetadata |

	metadata := Metadata 
		attaching: 'celsius'
		as: #unit_name 
		of: self temperatureStream.

	equivalentMetadata := Metadata
		attaching: 'celsius'
		as: #unit_name
		of: self temperatureStream.

	differentMetadata := Metadata
		attaching: 'Fahrenheit'
		as: #unit_name
		of: self temperatureStream.

	self
		assert: metadata hash equals: equivalentMetadata hash;
		deny: metadata hash = differentMetadata hash
]

{ #category : #tests }
MetadataTest >> testInstanceCreationAndAccessing [

	| metadata |

	metadata := Metadata
		attaching: 'celsius'
		as: #unit_name
		of: self temperatureStream.
	self
		assert: metadata describedObject equals: self temperatureStream;
		assert: metadata aspect equals: #unit_name;
		assert: metadata data equals: 'celsius'
]

{ #category : #tests }
MetadataTest >> testPrintOn [

	| metadata |

	metadata := Metadata
		attaching: 'celsius'
		as: #unit_name
		of: self temperatureStream.
	self
		assert: metadata printString
		equals:
			('<1p> of <2p> is <3p>'
				expandMacrosWith: metadata aspect
				with: metadata describedObject
				with: metadata data)
]
