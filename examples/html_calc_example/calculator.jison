
/* description: Parses end executes mathematical expressions. */

/* Declaración de variables js */
%{
	var variables = {};
%}

/* lexical grammar */
%lex
%%

\s+                   /* skip whitespace */
\/\s*0+\b 	      return 'DZ'
[0-9]+("."[0-9]+)?\b  return 'NUMBER'
"*"                   return '*'
"/"                   return '/'
"-"                   return '-'
"+"                   return '+'
"^"                   return '^'
"!"                   return '!'
"%"                   return '%'
"("                   return '('
")"                   return ')'
[;]+                  return ';'
"="		      return '='
"PI"                  return 'PI'
"E"                   return 'E'
[a-zA-Z_]+            return 'ID'
<<EOF>>               return 'EOF'
.                     return 'INVALID'

/lex

/* operator associations and precedence */

%left '+' '-'
%left '*' '/' DZ
%left '^'
%right '!'
%right '%'
%left ID 
%left equal
%left UMINUS

%start expressions

%% /* language grammar */

expressions
    : e EOF
        { typeof console !== 'undefined' ? console.log($1) : print($1);
          return $1; }
    ;

e
    : e '+' e
        {$$ = $1+$3;}
    | e '-' e
        {$$ = $1-$3;}
    | e '*' e
        {$$ = $1*$3;}
    | e DZ
  	{ return "Se esta intentando dividir por 0"; }
    | e '/' e
        {$$ = $1/$3;}
    | e '^' e
        {$$ = Math.pow($1, $3);}
    | e '!'
        {{
          $$ = (function fact (n) { return n==0 ? 1 : fact(n-1) * n })($1);
        }}
    | e '%'
        {$$ = $1/100;}
    | '-' e %prec UMINUS
        {$$ = -$2;}
    | '(' e ')'
        {$$ = $2;}
    | NUMBER
        {$$ = Number(yytext);}
    | E
        {$$ = Math.E;}
    | PI
        {$$ = Math.PI;}
    | ID
	{
		console.log("Localizado id"); 
			
		if( $1 in variables) {
			$$ = variables[$1];
		} 
		else{ 
			return "No existe la variable "+$1;	
		}	
	}

    | equal e 
	{
		$$ = $2;
	}
    | equal
	{
		$$ = $1
	}
    | PI '=' e ';'
	{ return "Se esta intenando modificar el PI"; }
    | E '=' e ';'
	{ return "Se esta intenando modificar el E"; }
    ;

equal : 
      ID '=' e ';' 
	{variables[$1] = $3; console.log($1 + "=" + $3); $$ = $3; }
    ;
	

