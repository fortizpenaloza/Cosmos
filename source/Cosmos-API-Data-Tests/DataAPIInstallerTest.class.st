Class {
	#name : #DataAPIInstallerTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Data-Tests'
}

{ #category : #tests }
DataAPIInstallerTest >> testInstallation [

	| teapot |

	teapot := Teapot on.
	(DataWebServiceSpecification toInstallOn: teapot workingWith: self) install.

	self assert: teapot routes size equals: 6
]
