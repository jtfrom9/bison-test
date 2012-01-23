%{                                            /* -*- C++ -*- */
#include <cstdlib>
#include <errno.h>
#include <limits.h>
#include <string>
#include "Scanner.hpp"

/* Work around an incompatibility in flex (at least versions
   2.5.31 through 2.5.33): it generates code that does
   not conform to C89.  See Debian bug 333231
   <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=333231>.  */
#undef yywrap
#define yywrap() 1


/* By default yylex returns int, we use token_type.
   Unfortunately yyterminate by default returns 0, which is
   not of token_type.  */
#define yyterminate() return token::END

%}

%option c++
%option yyclass="Scanner"
%option noyywrap nounput batch debug


id    [a-zA-Z][a-zA-Z_0-9]*
int   [0-9]+
blank [ \t]


%{
#define YY_USER_ACTION  location->columns(yyleng);
%}



%% // ---- Ç±Ç±Ç©ÇÁéöãÂíËã`


%{ // ??
  location->step();
%}

{blank}+   location->step();
[\n]+      location->lines(yyleng); location->step();


%{ // ??
  typedef yy::Parser::token token;
%}


[-+*/]     return yy::Parser::token_type (yytext[0]);
":="       return token::ASSIGN;
{int}      {
	errno = 0;
	long n = strtol (yytext, NULL, 10);
	if (! (INT_MIN <= n && n <= INT_MAX && errno != ERANGE))
		driver.error (*location, "integer is out of range");
	value->ival = n;
	return token::NUMBER;
}
{id}       value->sval = new std::string (yytext); return token::IDENTIFIER;
.          driver.error (*location, "invalid character");


%% // ---- Ç±Ç±Ç©ÇÁC++ãLèq

