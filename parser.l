letter   [A-Za-z]
word     {letter}+
comma    [,]
digit    [0-9]
number   {digit}+

%s 

%%
word     {printf("%s", word);}


%%
main() {
  yylex();
}
