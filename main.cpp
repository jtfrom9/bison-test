#include <iostream>
#include "ParseDriver.hpp"

int
main (int argc, char *argv[])
{
    ParseDriver driver;
    for (++argv; argv[0]; ++argv) {
        if (*argv == std::string ("-p")) {
            driver.trace_parsing = true;
        }
        else if (*argv == std::string ("-s")) {
            driver.trace_scanning = true;
        }
        else {
            driver.run(*argv);
            std::cout << driver.result << std::endl;
        }
    }
}
