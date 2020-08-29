.PHONY: clean check

VPATH = src include
CPPFLAGS = -I include

count_words: count_words.o counter.o lexer.o -lfl
	gcc $(CPPFLAGS) $^ -o $@

count_words.o: count_words.c counter.h
	gcc $(CPPFLAGS) -c $< 

counter.o: counter.c include/lexer.h include/counter.h
	gcc $(CPPFLAGS) -c $< 

lexer.o: lexer.c include/lexer.h
	gcc $(CPPFLAGS) -c $< 

lexer.c: lexer.l
	flex -t $< > $@

hello: hello.c
	gcc $(CPPFLAGS) $< -o $@


clean:
	rm *.o
	rm lexer.c
	rm count_words

check: count_words
	cat count_words.test | ./count_words
