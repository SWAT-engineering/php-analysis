module \test::lang::php::util::Utils

import lang::php::util::Utils;

// folder tests
public test bool testIsTestFolder1() = true == isTestFolder("test");
public test bool testIsTestFolder2() = true == isTestFolder("tests");
public test bool testIsTestFolder3() = true == isTestFolder("Test");
public test bool testIsTestFolder4() = true == isTestFolder("Tests");
public test bool testIsTestFolder5() = false == isTestFolder("dummy");
public test bool testIsTestFolder6() = false == isTestFolder("randomFolderTest");
public test bool testIsTestFolder7() = false == isTestFolder("TestRandomFolder");
public test bool testIsTestFolder8() = false == isTestFolder("RandomTestFolder");
public test bool testIsTestFolder9() = false == isTestFolder("100");
// refactored
list[loc] validFolders = [|file://somefolder/test|,|file://somefolder/tests|,|file://somefolder/Test|,|file://somefolder/Tests|];
list[loc] invalidFolders = [|file://somefolder/dummy|, |file://somefolder/randomFolderTest|, |file://somefolder/TestRandomFolder|, |file://somefolder/RandomTestFolder|, |file://somefolder/100|];
public test bool testIsTestFolderValid() = true == all(dir <- validFolders, isTestFolder(dir));
public test bool testIsTestFolderInvalid() = true == !any(dir <- invalidFolders, isTestFolder(dir));

// file tests
public test bool testIsTestFile1() = true == isTestFile("RandomClassTest.php");
public test bool testIsTestFile2() = true == isTestFile("AnotherClassTest.php");
public test bool testIsTestFile3() = false == isTestFile("Test.php");
public test bool testIsTestFile4() = false == isTestFile("randomfile.php");
public test bool testIsTestFile5() = false == isTestFile("test");
public test bool testIsTestFile6() = false == isTestFile("Tests");
public test bool testIsTestFile7() = false == isTestFile("Test");
public test bool testIsTestFile8() = false == isTestFile("tests");
public test bool testIsTestFile9() = false == isTestFile("MupltipleTests.php");
// refactored tests
list[loc] validFiles = [|file://somefolder/RandomClassTest.php|, |file://somefolder/AnotherClassTest.php|];
list[loc] invalidFiles = [|file://somefolder/Test.php|, |file://somefolder/randomfile.php|, |file://somefolder/MultipleTests|] + validFolders;
public test bool testIsTestFileValid() = true == all(dir <- validFiles, isTestFile(dir));
public test bool testIsTestFileInvalid() = true == !any(dir <- invalidFiles, isTestFile(dir));