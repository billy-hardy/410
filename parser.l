letter   [A-Za-z]
word     {letter}+
words    {word}*\ *{word}+
comma    [,]
d        [0-9]
number   {d}+
float    {d}+\.{d}+
year     {d}{4}

%s HNUMBER DNUMBER FNUMBER LNAME FNAME RELATE OWN FORR SEX RACE AGE MARITAL IMMYEAR NAT NATYEAR ATTSCH READ WRITE BPLACE LANG FPLACE FLANG MPLACE MLANG ENG PROF IND EMP FSCHED

%{
#include <stdio.h>
#include <string.h>

typedef struct {
  int line;
  float hnumber;
  int dnumber, fnumber;
  char lname[50], fname[50], relate[50];
  int own, forr; //boolean own and 1 for rent, 0 for free
  char sex, race;
  int age, month;
  char marital;
  int immYear, nat;
  int natYear, attSch, read, write;
  char bPlace[30], lang[30], fPlace[30], fLang[30], mPlace[30], mLang[30];
  int eng;
  char prof[30], ind[30], emp[30];
} person;

typedef struct {
  person people[10];
  int count;
  int fNumber;
  char lName[50];
} family;

typedef struct {
  family families[10];
  int count;
  int hNumber, dNumber;
} house;

typedef struct {
  char places[100][100];
  int freq[100];
  int count;
} hMap;

void putInBucket(char[], hMap *);

void reaper(person *);

person p;
person people[100];
int pc = 0;
int tHNum, tDNum, tFNum;
char tLName[50];

%}

%%
<INITIAL>{number}    p.line = atoi(yytext);
<INITIAL>,           BEGIN(HNUMBER);
<HNUMBER>{float}     p.hnumber = atof(yytext);
<HNUMBER>,           BEGIN(DNUMBER);
<DNUMBER>{number}    p.dnumber = atoi(yytext);
<DNUMBER>,           BEGIN(FNUMBER);
<FNUMBER>{number}    p.fnumber = atoi(yytext);
<FNUMBER>,           BEGIN(LNAME);
<LNAME>{word}        strcpy(p.lname, yytext);
<LNAME>,             BEGIN(FNAME);
<FNAME>{words}       strcpy(p.fname, yytext);
<FNAME>,             BEGIN(RELATE);
<RELATE>{word}       strcpy(p.relate, yytext);
<RELATE>,            BEGIN(OWN);
<OWN>{letter}        p.own = strcmp(yytext, "O");
<OWN>,               BEGIN(FORR);
<FORR>{letter}       p.forr = strcmp(yytext, "M");
<FORR>,              BEGIN(SEX);
<SEX>{letter}        p.sex = yytext[0];
<SEX>,               BEGIN(RACE);
<RACE>{letter}       p.race = yytext[0];
<RACE>,              BEGIN(AGE);
<AGE>age             p.age = atoi(yytext);
<AGE>{d}+/[\/12]     p.month = atoi(yytext);
<AGE>,               BEGIN(MARITAL);
<MARITAL>{letter}    p.marital = yytext[0];
<MARITAL>,           BEGIN(IMMYEAR);
<IMMYEAR>{year}      p.immYear = atoi(yytext);
<IMMYEAR>,           BEGIN(NAT);
<NAT>Na              p.nat = 1;
<NAT>,               BEGIN(NATYEAR);
<NATYEAR>{year}      p.natYear = atoi(yytext);
<NATYEAR>,           BEGIN(ATTSCH);
<ATTSCH>yes          p.attSch = 1;
<ATTSCH>,            BEGIN(READ);
<READ>yes            p.read = 1;
<READ>,              BEGIN(WRITE);
<WRITE>yes           p.write = 1;
<WRITE>,             BEGIN(BPLACE);
<BPLACE>{words}      strcpy(p.bPlace, yytext);
<BPLACE>,            BEGIN(LANG);
<LANG>{word}         strcpy(p.lang, yytext);
<LANG>,              BEGIN(FPLACE);
<FPLACE>{words}      strcpy(p.fPlace, yytext);
<FPLACE>,            BEGIN(FLANG);
<FLANG>{word}        strcpy(p.fLang, yytext);
<FLANG>,             BEGIN(MPLACE);
<MPLACE>{words}      strcpy(p.mPlace, yytext);
<MPLACE>,            BEGIN(MLANG);
<MLANG>{word}        strcpy(p.mLang, yytext);
<MLANG>,             BEGIN(ENG);
<ENG>yes             p.eng = 1;
<ENG>,               BEGIN(PROF);
<PROF>{words}        strcpy(p.prof, yytext);
<PROF>,              BEGIN(IND);
<IND>{words}         strcpy(p.ind, yytext);
<IND>,               BEGIN(EMP);
<EMP>{word}          strcpy(p.emp, yytext);
<EMP>,               BEGIN(FSCHED);
<FSCHED>\n           {people[pc++] = p; reaper(&p); BEGIN(0);}

%%
main() {
  yylex();
  hMap birthPlaces;
  birthPlaces.count = 0;
  int i;
  for(i=0; i<pc; i++) {
    putInBucket(people[i].bPlace, &birthPlaces);
  }
  for(i=0; i<birthPlaces.count; i++) {
    printf("%s: %i\n", birthPlaces.places[i], birthPlaces.freq[i]);
  } 
}

void putInBucket(char place[], hMap *bp) {
  int i;
  for(i=0; i<bp->count; i++) {
    if(strcmp(place, bp->places[i])) {
      bp->freq[i]++;
      break;
    }
  }
  if(i==bp->count) {
    strcpy(bp->places[i], place);
    bp->count++;
  }
}

void reaper(person *per) {
  int tHNum, tDNum, tFNum;
  char tLName[50];
  tHNum = per->hnumber;
  tDNum = per->dnumber;
  tFNum = per->fnumber;
  strcpy(tLName, per->lname); 
  *per = {NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL};
  per->hnumber = tHNum;
  per->dnumber = tDNum;
  per->fnumber = tFNum;
  strcpy(per->lname, tLName);
}