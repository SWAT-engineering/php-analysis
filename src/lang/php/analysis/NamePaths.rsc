@license{
  Copyright (c) 2009-2011 CWI
  All rights reserved. This program and the accompanying materials
  are made available under the terms of the Eclipse Public License v1.0
  which accompanies this distribution, and is available at
  http://www.eclipse.org/legal/epl-v10.html
}
@contributor{Mark Hills - Mark.Hills@cwi.nl (CWI)}
module lang::php::analysis::NamePaths

data NamePart 
	= root() 
	| global() 
	| class(str className)
	| interface(str interfaceName)
	| method(str methodName) 
	| field(str fieldName) 
	| var(str varName) 
	| arrayContents() 
	;
	
alias NamePath = list[NamePart];