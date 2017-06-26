accessing
packagesToBeChecked

	^ RPackage organizer packages select: [:package | package name beginsWith: 'IoT-' ]