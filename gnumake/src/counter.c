#include "lexer.h"
#include "counter.h"
void countser(int counts[4]){
	while(yylex())
	;

	counts[0] = fee_count;
	counts[1] = fie_count;
	counts[2] = foe_count;
	counts[2] = fum_count;
}
