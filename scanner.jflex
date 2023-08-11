import java.io.*;
import java_cup.runtime.*;

%%

%unicode
%cup
%line
%column



%{
  private Symbol sym(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol sym(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
	
  }
%}

//~
nl = \r|\n|\r\n
ws = [ \t]

real = ("+"|"-")?(([0-9]+\.[0-9]*)|([0-9]*\.[0-9]+))((e|E)(\+|\-)?[0-9]+)?
ureal = (([0-9]+\.[0-9]*)|([0-9]*\.[0-9]+))((e|E)(\+|\-)?[0-9]+)? 

uint = 0| [1-9][0-9]*
signedInteger = 0 | [+-]?[1-9][0-9]*


qstring= \" ~ \"

comment="{{"~"}}" | \/\/(.*)


tok1={hex}"*"({alpha}{5}({alpha}{alpha})*)"-"( (("****")("**")*) | ("Y"("X")("X")*"Y"))?

hex=27A | [a-zA-Z0-9]{3} | 0[a-zA-Z0-9]{3} | 12[aA][a-zA-Z0-9] | 12[bB][0-3] | 11[a-zA-Z0-9][a-zA-Z0-9]
alpha=[a-zA-Z]


tok2={ip}"-"{date}
ip={num}"."{num}"."{num}"."{num}
num=[0-9]|[1-9][0-9]| 1[0-9][0-9] | 2[0-4][0-9] | 25[0-5] 
date=((((0[5-9])| ([12][0-9] )| (3[01]))"/"10"/"2023 )| (((0[1-9])| ([12][0-9] )| (30))"/"11"/"2023 )| (((0[1-9])| ([12][0-9] )| (3[01]))"/"12"/"2023 )
	| (((0[1-9])| ([12][0-9] )| (3[01]))"/"01"/"2024 ) | (((0[1-9])| ([12][0-9] ))"/"02"/"2024 ) | (((0[1-3]))"/"03"/"2024 ) )


tok3=(((([0-9][0-9][0-9][0-9]) | ([0-9][0-9][0-9][0-9][0-9][0-9]))["-""+"]){2}) (([0-9][0-9][0-9][0-9]) | ([0-9][0-9][0-9][0-9][0-9][0-9]) )
	 | (((([0-9][0-9][0-9][0-9]) | ([0-9][0-9][0-9][0-9][0-9][0-9]))["-""+"]{4}) (([0-9][0-9][0-9][0-9] )| ([0-9][0-9][0-9][0-9][0-9][0-9])))




%%

"***"  {return new Symbol(sym.SEP);}

";" {return new Symbol(sym.SC);}
"," {return new Symbol(sym.CM);}

"-" {return new Symbol(sym.MINUS);}
"%" {return new Symbol(sym.PERCENT);}

"euro" {return sym(sym.EURO,new String(yytext()));}


{tok1} {return new Symbol(sym.TOK1);}
{tok2} {return new Symbol(sym.TOK2);}
{tok3} {return new Symbol(sym.TOK3);}




{ureal} {return sym(sym.UREAL,new Double(yytext()));}
{uint}  {return sym(sym.UINT,new Integer(yytext()));}

{qstring} {return sym(sym.QSTRING,new String(yytext()));}



{comment} {;}
\n|\r|\r\n 	{;}
[ \t]		{;}