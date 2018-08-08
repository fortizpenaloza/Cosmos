Class {
	#name : #MetadataTest,
	#superclass : #TestCase,
	#category : #'Cosmos-Metadata-Tests'
}

{ #category : #accessing }
MetadataTest >> temperatureStream [
	
	^ DataStream named: 'Temperature' createdOn: December tenth , 2016
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
		assert: metadata value equals: 'celsius'
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
				with: metadata value)
]
