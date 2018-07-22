grammar xyz:remexre:simpdep:concretesyntax;

lexer class COMMENT dominates OPERATOR;
lexer class IDENTIFIER;
lexer class KEYWORD dominates IDENTIFIER;
lexer class LITERAL;
lexer class OPERATOR;

terminal Multiply_t         '*'  precedence = 4, association = left, lexer classes {OPERATOR};
terminal Divide_t           '/'  precedence = 4, association = left, lexer classes {OPERATOR};
terminal Plus_t             '+'  precedence = 3, association = left, lexer classes {OPERATOR};
terminal Minus_t            '-'  precedence = 3, association = left, lexer classes {OPERATOR};
terminal DoubleEqual_t      '==' precedence = 2, association = left, lexer classes {OPERATOR};
terminal NotEqual_t         '!=' precedence = 2, association = left, lexer classes {OPERATOR};
terminal Greater_t          '>'  precedence = 2, association = left, lexer classes {OPERATOR};
terminal GreaterThanEqual_t '>=' precedence = 2, association = left, lexer classes {OPERATOR};
terminal LessThan_t         '<'  precedence = 2, association = left, lexer classes {OPERATOR};
terminal LessThanEqual_t    '<=' precedence = 2, association = left, lexer classes {OPERATOR};
terminal And_t              '&&' precedence = 1, association = left, lexer classes {OPERATOR};
terminal Or_t               '||' precedence = 1, association = left, lexer classes {OPERATOR};
terminal Not_t              '!'  precedence = 1, association = left, lexer classes {OPERATOR};

terminal Equal_t            '=' lexer classes {OPERATOR};
terminal Semicolon_t        ';' lexer classes {OPERATOR};
terminal Hole_t             '_' lexer classes {KEYWORD};
terminal LParen_t           '(' precedence = 5;
terminal RParen_t           ')' precedence = 5;
terminal LImplicit_t        '<{' precedence = 5;
terminal RImplicit_t        '}>' precedence = 5;
terminal LBrack_t           '[';
terminal RBrack_t           ']';
terminal LBrace_t           '{';
terminal RBrace_t           '}';
terminal Comma_t            ',';

terminal Identifier_t /[A-Za-z][A-Za-z0-9]*/ lexer classes {IDENTIFIER}, named "an identifier";
terminal Int_t        /[0-9]+/               lexer classes {LITERAL}, named "an integer";
terminal False_t      'false'                lexer classes {KEYWORD, LITERAL};
terminal True_t       'true'                 lexer classes {KEYWORD, LITERAL};

ignore terminal Whitespace_t   /[\n\r\t\ ]+/ named "whitespace";
ignore terminal LineComment_t  /\/\/.*/ lexer classes {COMMENT}, named "a comment";
