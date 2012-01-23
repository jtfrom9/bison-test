#ifndef __SCANNER_HPP__
#define __SCANNER_HPP__

#include <iostream>
#include <fstream>
using namespace std;

#undef yyFlexLexer
#include<FlexLexer.h>


/* 前方参照(ScannerとParseDriverは相互参照している) */
class Scanner;

#include "Parser.hpp"
#include "ParseDriver.hpp"


/*
 * YY_DECL によっては、スキャナの関数インターフェイスが決まる。
 * この時の仮引数は、スキャナのセマンティックアクション内で呼び出す事ができる。
*/
#undef YY_DECL
#define YY_DECL											\
	yy::Parser::token_type								\
	Scanner::scan( yy::Parser::semantic_type* value,	\
				   yy::Parser::location_type* location,	\
				   ParseDriver& driver)


class Scanner : public yyFlexLexer {
public:
	Scanner( ifstream &ifs ):
		yyFlexLexer(&ifs)
		{}
	YY_DECL;
};

#endif

