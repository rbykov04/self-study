.PHONE: all clean

HEAD     = S0BasicTypes
SNIPPETS += $(HEAD).class

all: $(SNIPPETS)
	java $(HEAD)

%.class : %.java
	@javac $<


clean:
	@rm -f *.class
