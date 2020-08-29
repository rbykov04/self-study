.PHONY: clean check

VPATH = src include
CPPFLAGS = -I include

count_words: count_words.o counter.o lexer.o -lfl
count_words.o: count_words.c counter.h
counter.o: counter.c include/lexer.h include/counter.h
lexer.o: lexer.c include/lexer.h
lexer.c: lexer.l
hello: hello.c

%.o:%.c
	$(COMPILE.c) $(OUTPUT_OPTIONS) $<

%.c:%.l
	@$(RM) $@
	$(LEX.l) $< > $@

%: %.o
	$(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@


clean:
	rm *.o
	rm lexer.c
	rm count_words

check: count_words
	cat count_words.test | ./count_words
