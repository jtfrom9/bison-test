CXX=g++
BISON=bison
FLEX=flex
TARGET=ptest
OBJS=Parser.o Scanner.o ParseDriver.o main.o 

CFLAGS=-g

$(TARGET): $(OBJS)
	@export LC_ALL=C
	$(CXX) $(OBJS) $(CFLAGS) -o $@ 

Parser.cpp: parser.y
	$(BISON) -o $@ $< 

Scanner.cpp: scanner.l
	$(FLEX)  -o $@ $< 

.SUFFIXES:.cpp.o
.cpp.o:
	$(CXX) $(CFLAGS) -c $<  


clean:
	rm -f $(OBJS) $(TARGET).exe location.hh position.hh stack.hh Parser.cpp Parser.hpp Scanner.cpp

