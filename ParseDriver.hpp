#ifndef __PARSEDRIVER_H__
#define __PARSEDRIVER_H__

#include <string>
#include <map>
#include "Parser.hpp"
#include "Scanner.hpp"

class Argument
{
    std::string name;

public:
    Argument(const char* _name):
        name(_name)
    {}

    const std::string& Name() const { return name; }
};

#include<vector>
#include<sstream>

class ArgumentList
{
private:
    std::vector<Argument> list;

public:
    void Add(const Argument& arg)
    {
        list.push_back(arg);
    }

    std::string ToString()
    {
        std::stringstream ss;
        bool first=true;
        for(std::vector<Argument>::iterator i=list.begin(); i!=list.end(); i++) {
            if(!first) {
                ss << ",";
            }
            first = false;
            ss << i->Name();
        }
        return ss.str();
        //return "";
    }
};


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

    ArgumentList List;
};


#endif
