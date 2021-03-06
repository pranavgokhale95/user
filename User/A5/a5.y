%{

#include "stdio.h"
#include "string.h"

extern FILE* yyin;

struct tbl_row{
	char type[20];
	char val[20];
}sym_tbl[50];

struct quad_row{
	char op1[20];
	char op2[20];
	char res[20];		
	char op;

}quad_tbl[50];

int sym_index=0;
int quad_index=0;

struct stack_item{
	char item[20];
}stk[50];

int top=-1;

int temp_index=0;

void insertIntoSymbolTable(char*,char*);
void insertIntoQuadTable(char*,char*,char*,char);

void push(char*);
char* pop();

%}

%union 
{
	char sval[10];
}

%token MAIN 

%token <sval> NUM 
%token <sval> ID 
%token <sval> DT


%left '+' '-'
%left '*' '/'

%start program

%%

program: MAIN '(' ')' '{' stmlist '}'	{ printf("correct program\n"); }
	;

stmlist: varlist s
	;


varlist: varstmt varlist			
	|
	;

varstmt: DT vardec ';'				
	;

vardec: ID ',' vardec			{ 	insertIntoSymbolTable($1,"0"); }
	| ID '=' NUM ',' vardec 	{ 	insertIntoSymbolTable($1,$3); }
	| ID '=' NUM			{ 	insertIntoSymbolTable($1,$3); }
	| ID				{ 	insertIntoSymbolTable($1,"0"); }
	;

s	: stmt s
	|
	;

stmt	: ID '=' expr ';'		{ 	insertIntoQuadTable(pop()," ",$1,'='); }
	| expr';'
	;

expr	: expr '+' expr			{
						char temp[4];
						sprintf(temp,"t%d",temp_index);						
						insertIntoQuadTable(pop(),pop(),temp,'+');
						push(temp);
						temp_index++;

					}

	| expr '-' expr			{
						char temp[4]="t";
						sprintf(temp,"%d",temp_index);						
						insertIntoQuadTable(pop(),pop(),temp,'-');
						push(temp);
						temp_index++;

					}

	| expr '*' expr			{
						char temp[4];
						sprintf(temp,"t%d",temp_index);						
						insertIntoQuadTable(pop(),pop(),temp,'*');
						push(temp);
						temp_index++;

					}		
			
	| expr '/' expr			{	char temp[4];
						sprintf(temp,"t%d",temp_index);						
						insertIntoQuadTable(pop(),pop(),temp,'/');
						push(temp);
						temp_index++;

					}
	
	| NUM				{ 	push($1); }
	| ID				{ 	push($1); }
	;

%%
int yyerror(char* st){
	printf("syntax error %s\n",st);
}

int yywrap(){
	return 1;
}

int main(){
	FILE* in = fopen("input.c","r");
	yyin=in;
	yyparse();

	int i=0;

	printf("\n\n Symbol Table \n\n");

	for(i=0;i<sym_index;i++){
		printf("%s\t\t%s\n", sym_tbl[i].type,sym_tbl[i].val);
	}

	printf("\n\n Intermediate Code \n\n");

	for(i=0;i<quad_index;i++){
		printf("%s\t\t%s\t\t%s\t\t%c\n", quad_tbl[i].op1,quad_tbl[i].op2,quad_tbl[i].res,quad_tbl[i].op);
	}

	fclose(in);
	return 0;
}

void insertIntoSymbolTable(char* type,char* val){
	strcpy(sym_tbl[sym_index].type,type);
	strcpy(sym_tbl[sym_index].val,val);
	sym_index++;
}

void insertIntoQuadTable(char* op1,char* op2,char* res,char op){
	struct quad_row row;
	strcpy(row.op1,op1);
	strcpy(row.op2,op2);
	strcpy(row.res,res);
	row.op=op;
	quad_tbl[quad_index]=row;
	quad_index++;
}

void push(char* s){
	struct stack_item item;

	strcpy(item.item,s);
	stk[++top]=item;
}

char* pop(){
	char* str = stk[top--].item;
	return str;
}
