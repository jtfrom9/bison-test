%skeleton "lalr1.cc"
%require "2.1a"

%defines
%define "parser_class_name" "Parser"

%debug
%error-verbose

%parse-param { ParseDriver& driver }  //Parser���饹���󥹥ȥ饯�����裱����
%lex-param   { ParseDriver& driver }  //yylex()�ؿ����裳����

%locations
%initial-action
{
  // Initialize the initial location.
  @$.begin.filename = @$.end.filename = &driver.file;
};

%{
// ���������ѡ����Υإå��ե�����(Parser���饹������ե�����)�Ǥ�
// ParseDriver�����Ȥ���ɬ��
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



// ��%union������μ������%{ }%��ʬ�ϡ��������ե�����˽��Ϥ����
%{
#include "ParseDriver.hpp"

// �ѡ������鸫��������ʤؤ�I/F�ؿ�(yylex())
// ��yylex()�Ȥ����ؿ�̾�ϡ�bison��������ͤʤΤ��Ѥ����ʤ���
// ����1����(yylval)����2����(yylloc)�η���bison���͡�
//   ���������֤��ͤ���3�����ϼ�ͳ������Ǥ��뤷��
//   ������̾(yylval,yylloc) �⼫ͳ��
yy::Parser::token_type
yylex(yy::Parser::semantic_type* yylval,
	  yy::Parser::location_type* yylloc,
	  ParseDriver& driver)
{
	driver.scanner->scan(yylval,yylloc,driver);
}

// �ѡ����Υ��顼��ݡ����ѥ᥽�å�
// �桼�����������뤳�Ȥ�Bison�λ���
void
yy::Parser::error(const yy::Parser::location_type& l,
				  const std::string& m)
{
	driver.error(l, m);
}

%}




%% // ---- ��������ʸˡ���


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


%% // ----- ��������C++����

