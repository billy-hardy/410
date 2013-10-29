#include <stdio.h>
#include <string.h>
#include "lisp.h"

void main(int argc, char *argv[]) {
  environment global_env;
  add_globals(global_env);
  if(argc == 1) {
    repl("lisp>");
  } else {
    int i;
    for(i=1; i<argc; i++) {
      readFromFile(argv[i]);
    }
  }
}

void repl(const char *prompt, environment *env) {
  printf(prompt);
  char input[256];
  gets(input);
  eval(input, env)
