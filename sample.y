%token NUMBER IF THEN ELSE

%%


stmt:     expr
        | if_stmt
		| hoge
        ;

if_stmt:
          IF expr THEN stmt
        | IF expr THEN stmt ELSE stmt
        ;
expr:     term '+' expr
        | term
        ;

term:     '(' expr ')'
        | term '!'
        | NUMBER
        ;


hoge:   hoge '-' hoge
        | hoge '*' hoge
        | hoge '<' hoge
        | '(' hoge ')'
		| NUMBER
        ;

%%

