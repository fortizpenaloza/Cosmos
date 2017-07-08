accessing
packagesToBeChecked

	^ RPackage organizer packages select: [ :package | #('Cosmos-' 'Kepler-') anySatisfy: [ :prefix | package name beginsWith: prefix ] ]