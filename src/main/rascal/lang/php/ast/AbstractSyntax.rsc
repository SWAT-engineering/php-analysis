@license{ Copyright (c) 2009-2014 CWI
  All rights reserved. This program and the accompanying materials
  are made available under the terms of the Eclipse Public License v1.0
  which accompanies this distribution, and is available at
  http://www.eclipse.org/legal/epl-v10.html
}
@contributor{Mark Hills - Mark.Hills@cwi.nl (CWI)}
module lang::php::ast::AbstractSyntax

public data OptionExpr
	= someExpr(Expr expr) | noExpr();

public data OptionName
	= someName(Name name) | noName();

public data OptionElse
	= someElse(Else e) | noElse();

public data ActualParameter(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= actualParameter(Expr expr, bool byRef, bool isPacked);

public data Const(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= const(str name, Expr constValue);

public data ArrayElement(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= arrayElement(OptionExpr key, Expr val, bool byRef)
	| emptyElement();

public data Name(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= name(str name);

public data NameOrExpr(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= name(Name name)
	| expr(Expr expr);

public data ClassName
	= explicitClassName(Name name)
	| computedClassName(Expr expr)
	| anonymousClass(Stmt stmt);

public data CastType(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= \int()
	| \bool()
	| float()
	| string()
	| array()
	| object()
	| unset();

public data ClosureUse(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= closureUse(Expr varName, bool byRef);

public data IncludeType(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= include()
	| includeOnce()
	| require()
	| requireOnce();

public data PHPType
	= nullableType(PHPType nestedType)
	| regularType(Name typeName) 
	| noType();

// NOTE: In PHP, yield is a statement, but it can also be used as an expression.
// To handle this, we just treat it as an expression. The parser does this as well.
// TODO: listAssign is deprecated and will be removed in the future, this is now
// given as an assignment into a listExpr
public data Expr(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= array(list[ArrayElement] items, bool usesBracketNotation)
	| fetchArrayDim(Expr var, OptionExpr dim)
	| fetchClassConst(NameOrExpr className, str constantName)
	| assign(Expr assignTo, Expr assignExpr)
	| assignWOp(Expr assignTo, Expr assignExpr, Op operation)
	| listAssign(list[OptionExpr] assignsTo, Expr assignExpr) // NOTE: deprecated, no longer appears in ASTs
	| refAssign(Expr assignTo, Expr assignExpr)
	| binaryOperation(Expr left, Expr right, Op operation)
	| unaryOperation(Expr operand, Op operation)
	| new(ClassName classToInstantiate, list[ActualParameter] parameters)
	| cast(CastType castType, Expr expr)
	| clone(Expr expr)
	| closure(list[Stmt] statements, list[Param] params, list[ClosureUse] closureUses, bool byRef, bool static, PHPType returnType)
	| fetchConst(Name name)
	| empty(Expr expr)
	| suppress(Expr expr)
	| eval(Expr expr)
	| exit(OptionExpr exitExpr, bool isExit)
	| call(NameOrExpr funName, list[ActualParameter] parameters)
	| methodCall(Expr target, NameOrExpr methodName, list[ActualParameter] parameters)
	| staticCall(NameOrExpr staticTarget, NameOrExpr methodName, list[ActualParameter] parameters)
	| include(Expr expr, IncludeType includeType)
	| instanceOf(Expr expr, NameOrExpr toCompare)
	| isSet(list[Expr] exprs)
	| print(Expr expr)
	| propertyFetch(Expr target, NameOrExpr propertyName)
	| shellExec(list[Expr] parts)
	| ternary(Expr cond, OptionExpr ifBranch, Expr elseBranch)
	| staticPropertyFetch(NameOrExpr className, NameOrExpr propertyName)
	| scalar(Scalar scalarVal)
	| var(NameOrExpr varName)	
	| yield(OptionExpr keyExpr, OptionExpr valueExpr)
	| yieldFrom(Expr fromExpr)
	| listExpr(list[ArrayElement] listExprs)
	;

public data Op(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= bitwiseAnd()
	| bitwiseOr()
	| bitwiseXor()
	| concat()
	| div()
	| minus()
	| \mod()
	| mul()
	| plus()
	| rightShift()
	| leftShift()
	| booleanAnd()
	| booleanOr()
	| booleanNot()
	| bitwiseNot()
	| gt()
	| geq()
	| logicalAnd()
	| logicalOr()
	| logicalXor()
	| notEqual()
	| notIdentical()
	| postDec()
	| preDec()
	| postInc()
	| preInc()
	| lt()
	| leq()
	| unaryPlus()
	| unaryMinus()
	| equal()
	| identical()
	| pow()
	| coalesce()
	| spaceship()
	;

public data Param(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= param(str paramName, OptionExpr paramDefault,bool byRef,bool isVariadic, PHPType paramType);

public data Scalar(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="", str actualValue="")
	= classConstant()
	| dirConstant()
	| fileConstant()
	| funcConstant()
	| lineConstant()
	| methodConstant()
	| namespaceConstant()
	| traitConstant()
	| float(real realVal)
	| integer(int intVal)
	| string(str strVal)
	| encapsed(list[Expr] parts)
	;

public data Stmt(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= \break(OptionExpr breakExpr)
	| classDef(ClassDef classDef)
	| const(list[Const] consts)
	| \continue(OptionExpr continueExpr)
	| declare(list[Declaration] decls, list[Stmt] body)
	| do(Expr cond, list[Stmt] body)
	| echo(list[Expr] exprs)
	| exprstmt(Expr expr)
	| \for(list[Expr] inits, list[Expr] conds, list[Expr] exprs, list[Stmt] body)
	| foreach(Expr arrayExpr, OptionExpr keyvar, bool byRef, Expr asVar, list[Stmt] body)
	| function(str name, bool byRef, list[Param] params, list[Stmt] body, PHPType returnType)
	| global(list[Expr] exprs)
	| goto(str label)
	| haltCompiler(str remainingText)
	| \if(Expr cond, list[Stmt] body, list[ElseIf] elseIfs, OptionElse elseClause)
	| inlineHTML(str htmlText)
	| interfaceDef(InterfaceDef interfaceDef)
	| traitDef(TraitDef traitDef)
	| label(str labelName)
	| namespace(OptionName nsName, list[Stmt] body)
	| namespaceHeader(Name namespaceName)
	| \return(OptionExpr returnExpr)
	| static(list[StaticVar] vars)
	| \switch(Expr cond, list[Case] cases)
	| \throw(Expr expr)
	| tryCatch(list[Stmt] body, list[Catch] catches)
	| tryCatchFinally(list[Stmt] body, list[Catch] catches, list[Stmt] finallyBody)
	| unset(list[Expr] unsetVars)
	| useStmt(list[Use] uses, UseType useType)
	| \while(Expr cond, list[Stmt] body)
	| emptyStmt()
	| block(list[Stmt] body)
	;

public data UseType
	= useTypeUnknown()
	| useTypeNormal()
	| useTypeFunction()
	| useTypeConst();

public data Declaration(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= declaration(str key, Expr val);

public data Catch(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= \catch(list[Name] xtypes, str varName, list[Stmt] body);

public data Case(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= \case(OptionExpr cond, list[Stmt] body);

public data ElseIf(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= elseIf(Expr cond, list[Stmt] body);

public data Else(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= \else(list[Stmt] body);

public data Use(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= use(Name importName, OptionName asName, UseType useType);

public data ClassItem(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= property(set[Modifier] modifiers, list[Property] prop)
	| constCI(list[Const] consts, set[Modifier] modifiers)
	| method(str name, set[Modifier] modifiers, bool byRef, list[Param] params, list[Stmt] body, PHPType returnType)
	| traitUse(list[Name] traits, list[Adaptation] adaptations)
	;

public data Adaptation
	= traitAlias(OptionName traitName, str methName, set[Modifier] newModifiers, OptionName newName)
	| traitPrecedence(OptionName traitName, str methName, set[Name] insteadOf)
	;

public data Property(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= property(str propertyName, OptionExpr defaultValue);

public data Modifier(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= \public()
	| \private()
	| protected()
	| static()
	| abstract()
	| final();

public data ClassDef(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= class(str className, set[Modifier] modifiers, OptionName extends, list[Name] implements, list[ClassItem] members);

public data InterfaceDef(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= interface(str interfaceName, list[Name] extends, list[ClassItem] members);

public data TraitDef
	= trait(str traitName, list[ClassItem] members);

public data StaticVar(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= staticVar(str name, OptionExpr defaultValue);

public data Script(loc at=|unknown:///|, loc decl=|unknown:///|, str id="", loc scope=|unknown:///|, str phpdoc="")
	= script(list[Stmt] body) | errscript(str err);

alias PhpParams = lrel[loc decl, set[loc] typeHints, bool isRequired, bool byRef];