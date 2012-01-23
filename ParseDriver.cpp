#include <iostream>
#include <fstream>
using namespace std;

#include "ParseDriver.hpp"
#include "Parser.hpp"

ParseDriver::ParseDriver ()
	: trace_scanning (false), trace_parsing (false)
{
	variables["one"] = 1;
	variables["two"] = 2;
}

ParseDriver::~ParseDriver ()
{
}

void
ParseDriver::error(const yy::location& l, const std::string& m)
{
	std::cerr << l << ": " << m << std::endl;
}

void
ParseDriver::run(const std::string &f) 
{
	file = f;

	ifstream ifs;
	ifs.open( f.c_str(), ios::in );
	scanner = new Scanner(ifs);	
	scanner->set_debug(trace_scanning);

	yy::Parser *parser = new yy::Parser(*this);
	parser->set_debug_level(trace_parsing);
	parser->parse();

	delete scanner;
	delete parser;
}

