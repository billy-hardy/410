letter   [a-zA-Z]
num      [0-9]
word     {letter}+
words    ({word}\ *)*{word}

%s QUESTION ANSWER WRONG

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define QNUM 1

typedef struct node {
  char text[300];
  struct node *next;
} node;

typedef struct {
  char text[200];
  node *answers;
  int ans_count;
  node *wrong_ans;
  int wrong_count;
} question;

question *questions[QNUM];
int count = 0;
question *q;

question *get_question(int i);
add_answer(question *quest, char ans[]);
add_wrong(question *quest, char wrong[]);

%}

%%
<INITIAL>num   {q = get_question(atoi(yytext));}
<INITIAL>,     BEGIN(ANSWER);
<ANSWER>words  {add_answer(q, yytext);}
<ANSWER>,      BEGIN(WRONG);
<WRONG>words   {add_wrong(q, yytext);}
<WRONG>\n      BEGIN(0);
.              ;



%%
main() {
  yylex();
  int i, j;
  FILE f = fopen("new_grad.pl", "w");
  node *curr;
  for(i=0; i<QNUM; i++) {
    curr = questions[i]->answers;
    for(j=0; j<questions[i]->ans_count; j++) {
      fprintf(f, "is_answer_to(q%i, %s).\n", i, curr->text);
      curr = curr->next;
    }
    curr = questions[i]->wrong_ans;
    for(j=0; j<questions[i]->wrong_count; j++) {
      fprintf(f, "is_wrong_answer_to(q%i, %s).\n", i, curr->text);
      curr = curr->next;
    }
  }
  fprintf(f, "is_answer_to(X,Y) :- \+ is_wrong_answer_to(X,Y).\n");
  fprintf(f, "is_wrong_answer_to(X,Y) :- \+ is_answer_to(X,Y).\n");
  scanf("%i", &i);
  fprintf(f, "?- is_answer_to(q%i, X).\n", i);
  fclose(f);
}

question *get_question(int i) {

}

add_answer(question *quest, char ans[]) {

}

add_wrong(question *quest, char wrong[]) {

}
