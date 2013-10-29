#ifndef LISP_H
#define LISP_H

typedef struct environment {
  struct environment *outer;
  //TODO: finish environment struct
} environment;

void repl(const char *, environment  *);
void read_from_file(char *, environment *);


#endif
