module lang::php::util::Utils

import util::ShellExec;
import IO;
import ValueIO;
import String;
import Set;
import Exception;

import lang::php::ast::AbstractSyntax;

public Script loadPHPFile(loc l) {
	println("Loading PHP file <l>");
	PID pid = createProcess("/usr/bin/php", ["/Users/mhills/Projects/phpsa/PHP-Parser/lib/Rascal/AST2Rascal.php", "<l.path>"], |file:///Users/mhills/Projects/phpsa/PHP-Parser/lib/Rascal|);
	str phcOutput = readEntireStream(pid);
	str phcErr = readEntireErrStream(pid);
	Script res = script([exprstmt(scalar(string("Could not parse file: <phcErr>")))]);
	if (trim(phcErr) == "") res = readTextValueString(#Script, phcOutput);
	killProcess(pid);
	return res;
}

public map[loc,Script] loadPHPFiles(loc l) {

	list[loc] entries = [ l + e | e <- listEntries(l) ];
	list[loc] dirEntries = [ e | e <- entries, isDirectory(e) ];
	list[loc] phpEntries = [ e | e <- entries, e.extension in {"php","inc"} ];

	map[loc,Script] phpNodes = ( );
	for (e <- phpEntries) {
		try {
			Script scr = loadPHPFile(e);
			phpNodes[e] = scr;
		} catch IO(msg) : {
			println("<msg>");
		} catch Java(msg) : {
			println("<msg>");
		}
	}
	for (d <- dirEntries) phpNodes = phpNodes + loadPHPFiles(d);
	
	return phpNodes;
}
