#ifndef __SCANNER_HPP__
#define __SCANNER_HPP__

#include <iostream>
#include <fstream>
using namespace std;

#undef yyFlexLexer
#include<FlexLexer.h>


/* �O���Q��(Scanner��ParseDriver�͑��ݎQ�Ƃ��Ă���) */
class Scanner;

#include "Parser.hpp"
#include "ParseDriver.hpp"


/*
 * YY_DECL �ɂ���ẮA�X�L���i�̊֐��C���^�[�t�F�C�X�����܂�B
 * ���̎��̉������́A�X�L���i�̃Z�}���e�B�b�N�A�N�V�������ŌĂяo�������ł���B
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

