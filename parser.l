letter   [A-Za-z]
word     {letter}+
quotes   \"{word}* *{word}*\"
comma    [,]
digit    [0-9]
number   {digit}+
float    {digit}+\.{digit}+

%s HNUMBER DNUMBER FNUMBER LNAME FNAME RELATE OWN FORR SEX RACE AGE MARITAL IMMYEAR NAT NATYEAR SCHYEAR READ WRITE BPLACE LANG FPLACE FLANG MPLACE MLANG ENG PROF IND EMP FSCHED

%{
#include <stdio.h>
#include <string.h>

typedef struct {
  int line;
  float hnumber;
  int dnumber, fnumber;
  char lname[30], fname[30], relate[30];
  int own, forr; //boolean own and 1 for rent, 0 for free
  char sex, race;
  float age;
  char marital[30];
  int immYear;
  char nation[30];
  int natYear, schYear, read, write;
  char bPlace[30], lang[30], fBPlace[30], fLang[30], mBPlace[30], mLang[30];
  int eng;
  char profession[30], industry[30], employer[30], farmSched[30];
} person;

typedef struct {
  person *head;
  person *members[10];
  int number;
} family;

typdef struct {
  family *main;
  family *tennants[10];
} house;


person *p;
family *f;
house *houses[50];
houseCounter = 0;
familyCounter = 0;
personCounter = 0;
%}


%%
<INITIAL>{digit}     {p = (person *) malloc(sizeof(person)); p->line = atoi(yytext);}     
<INITIAL>,           BEGIN(HNUMBER);
<HNUMBER>{float}     p->hnumber = atof(yytext);
<HNUMBER>,           BEGIN(DNUMBER);
<DNUMBER>{number}    p->dnumber = atoi(yytext);
<DNUMBER>,           BEGIN(FNUMBER);
<FNUMBER>{number}    p->fnumber = atoi(yytext);
<FNUMBER>,           BEGIN(LNAME);
<LNAME>\"{word}\"    strcpy(p->lname, yytext);
<LNAME>,             BEGIN(FNAME);
<FNAME>{quotes}      strcpy(p->fname, yytext);
<FNAME>,             BEGIN(RELATE);
<RELATE>\"{word}\"   strcpy(p->relate, yytext);
<RELATE>,            BEGIN(OWN);
<OWN>\"{letter}\"    p->own = (yytext=='O');
<OWN>,               BEGIN(FORR);
<FORR>\"{letter}\"   p->forr = (yytext=='M');
<FORR>,              BEGIN(SEX);
<SEX>\"{letter}\"    p->sex = yytext;
<SEX>,               BEGIN(RACE);
<RACE>\"{letter}\"   p->race = yytext;
<RACE>,              BEGIN(AGE);
<AGE>\"\"?{number}\" p->
<AGE>,               BEGIN(MARITAL);
<MARITAL>
<MARITAL>,           BEGIN(IMMYEAR);
<IMMYEAR>
<IMMYEAR>,           BEGIN(NAT);
<NAT>
<NAT>,               BEGIN(NATYEAR);
<NATYEAR>
<NATYEAR>,           BEGIN(SCHYEAR);
<SCHYEAR>
<SCHYEAR>,           BEGIN(READ);
<READ>
<READ>,              BEGIN(WRITE);
<WRITE>
<WRITE>,             BEGIN(BPLACE);
<BPLACE>
<BPLACE>,            BEGIN(LANG);
<LANG>
<LANG>,              BEGIN(FPLACE);
<FPLACE>
<FPLACE>,            BEGIN(FLANG);
<FLANG>
<FLANG>,             BEGIN(MPLACE);
<MPLACE>
<MPLACE>,            BEGIN(MLANG);
<MLANG>
<MLANG>,             BEGIN(ENG);
<ENG>
<ENG>,               BEGIN(PROF);
<PROF>
<PROF>,              BEGIN(IND);
<IND>
<IND>,               BEGIN(EMP);
<EMP>
<EMP>,               BEGIN(FSCHED);
<FSCHED>
<FSCHED>\n           {people[i++] = p; BEGIN(0);}
<FSCHED>,

%%
main() {
  yylex();
}
