%skeleton "lalr1.cc"
%require "2.1a"

%defines
%define "parser_class_name" "Parser"

%debug
%error-verbose

%parse-param { ParseDriver& driver }  //Parserクラスコンストラクタの第１引数
%lex-param   { ParseDriver& driver }  //yylex()関数の第３引数

%locations
%initial-action
{
  // Initialize the initial location.
  @$.begin.filename = @$.end.filename = &driver.file;
};

%{
// 生成されるパーサのヘッダファイル(Parserクラスの定義ファイル)では
// ParseDriverが型として必要
class ParseDriver;
%}

// Symbols.
%union
{
  int          ival;
  std::string *sval;
};

%token        END      0 "end of file"
%token        ASSIGN     ":="
%token <sval> IDENTIFIER "identifier"
%token <ival> NUMBER     "number"
%type  <ival> exp        "expression"

%printer    { debug_stream () << *$$; } "identifier"
%destructor { delete $$; } "identifier"
%printer    { debug_stream () << $$; } "number" "expression"



// ↓%unionの定義の次からの%{ }%部分は、ソースファイルに出力される
%{
#include "ParseDriver.hpp"

// パーサから見たスキャナへのI/F関数(yylex())
// ※yylex()という関数名は、bisonが定める仕様なので変えられない。
// ※第1引数(yylval)、第2引数(yylloc)の型もbison仕様。
//   ただし、返し値や第3引数は自由に定義できるし、
//   仮引数名(yylval,yylloc) も自由。
yy::Parser::token_type
yylex(yy::Parser::semantic_type* yylval,
	  yy::Parser::location_type* yylloc,
	  ParseDriver& driver)
{
	driver.scanner->scan(yylval,yylloc,driver);
}

// パーサのエラーレポート用メソッド
// ユーザが実装することがBisonの仕様
void
yy::Parser::error(const yy::Parser::location_type& l,
				  const std::string& m)
{
	driver.error(l, m);
}

%}




%% // ---- ここから文法定義


%start unit;
unit: assignments exp  { driver.result = $2; };

assignments: assignments assignment {}
           | /* Nothing.  */        {};

assignment: "identifier" ":=" exp { driver.variables[*$1] = $3; };

%left '+' '-';
%left '*' '/';
exp: exp '+' exp   { $$ = $1 + $3; }
   | exp '-' exp   { $$ = $1 - $3; }
   | exp '*' exp   { $$ = $1 * $3; }
   | exp '/' exp   { $$ = $1 / $3; }
   | "identifier"  { $$ = driver.variables[*$1]; }
   | "number"      { $$ = $1; };


%% // ----- ここからC++記述

