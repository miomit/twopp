import 'dart:math';

enum TokenType {
  bracketOpen,
  bracketClose,

  function,
  operation,

  number,
  constant,
}

class Token {
  final TokenType type;
  final String lexeme;
  Token({
    required this.type, 
    required this.lexeme,
  });

  @override String toString() {
    return "['$lexeme': $type]";
  }
}

class NumberType extends Token{
  late final num value;

  static const constants = {
    'PI': 3.14,
    'E' : 2.71,
    'G' : 0.91,
  };

  NumberType(String lexeme): super(
    type  : TokenType.number,
    lexeme: lexeme,
  ){
    var val = num.tryParse(lexeme);
    if (val == null) throw Exception("Lexical error :(");
    value = val;
  }

  NumberType.constant(String lexeme): super(
    type  : TokenType.constant,
    lexeme: lexeme,
  ){
    var c = constants[lexeme];
    if (c == null) throw Exception("Lexical error :(");
    value = c;
  }
}

class FunctionType extends Token {
  
  late final num Function(num) function;

  static final functions = {
    'sin' : (num x) => sin(x),
    'cos' : (num x) => cos(x),
    'tan' : (num x) => tan(x),

    'asin': (num x) => asin(x),
    'acos': (num x) => acos(x),
    'atan': (num x) => atan(x),

    'sqrt': (num x) => sqrt(x),
    'exp' : (num x) => exp(x),
    'log' : (num x) => log(x),

    'abs' : (num x) => x.isNegative? -x : x,
  };

  FunctionType(String lexem): super(
    type  :   TokenType.function,
    lexeme: lexem,
  ){
    var func = functions[lexeme];
    if (func == null) throw Exception("Lexical error :(");
    function = func;
  }
}

class OperationType extends Token {
  
  late final num Function(num, num) operation;
  late final int priority;

  static final operations = {
    '+': (fn: (num x, num y) => x + y, pr: 0),
    '-': (fn: (num x, num y) => x - y, pr: 0),

    '*': (fn: (num x, num y) => x * y, pr: 1),
    '/': (fn: (num x, num y) => x / y, pr: 1),

    '%': (fn: (num x, num y) => x % y, pr: 1),
    '^': (fn: (num x, num y) => pow(x, y), pr: 2),
  };

  OperationType(String lexem): super(
    type  :   TokenType.operation,
    lexeme: lexem,
  ){
    var opr = operations[lexeme];
    if (opr == null) throw Exception("Lexical error :(");
    operation = opr.fn;
    priority  = opr.pr;
  }
}

class BracketOpen extends Token {
  BracketOpen(): super(
    type  : TokenType.bracketOpen,
    lexeme: '(',
  );
}

class BracketClose extends Token {
  BracketClose(): super(
    type  : TokenType.bracketClose,
    lexeme: ')',
  );
}