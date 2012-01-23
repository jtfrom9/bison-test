#ifndef __PARSEDRIVER_H__
#define __PARSEDRIVER_H__

#include <string>
#include <map>
#include "Parser.hpp"
#include "Scanner.hpp"

class ParseDriver
{
public:
	std::string file;
	std::map<std::string, int> variables;
	int result;
	bool trace_scanning;
	bool trace_parsing;

	Scanner *scanner;

	ParseDriver();
	virtual ~ParseDriver();
	void error (const yy::location& l, const std::string& m);
	void run(const std::string& f);
};

#endif
