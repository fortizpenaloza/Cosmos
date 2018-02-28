parsing
parseNameFrom: rawAction 

	^ self parse: #name from: rawAction with: self nullParser