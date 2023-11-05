// ignore_for_file: prefer_function_declarations_over_variables, unused_local_variable

import 'package:calculator/src/token.dart';

const _alphabetUpper = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
const _alphabetLower = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};
const _alphabetNums  = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.'};

List<Token> lexer(String arg) => _lexer(arg.replaceAll(RegExp(' '), '').split(''));

List<Token> _lexer(List<String> arg){
  List<Token> result = [];
  String buffer = "";
  TokenType? state;
  
  var defineState = (char) {
    if (char == '(')                    return TokenType.bracketOpen;
    if (char == ')')                    return TokenType.bracketClose;
    if (_alphabetUpper.contains(char))  return TokenType.constant;
    if (_alphabetLower.contains(char))  return TokenType.function;
    if (_alphabetNums.contains(char))   return TokenType.number;

    return TokenType.operation;
  };

  var getType = () => switch(state) {
      TokenType.bracketOpen   => BracketOpen(),
      TokenType.bracketClose  => BracketClose(),
      TokenType.constant      => NumberType.constant(buffer),
      TokenType.number        => NumberType(buffer),
      TokenType.function      => FunctionType(buffer),
      _                       => OperationType(buffer),
  };

  arg.forEach((char) {
    if (state == null){
      state = defineState(char);
      buffer = char; 
    } else{
      var state_now = defineState(char);

      if (state_now == state && char != '(' && char != ')'){
        buffer += char;
      }else{
        result.add(getType());
        state = state_now;
        buffer = char;
      }
    }
  });

  result.add(getType());

  for (int i = 0; i < result.length; i++){
    switch(result.sublist(i)){
      case [NumberType _, NumberType _, ...]: 
      case [NumberType _, BracketOpen _, ...]: 
      case [BracketClose _, NumberType _, ...]: 
      case [BracketClose _, FunctionType _, ...]: 
      case [BracketClose _, BracketOpen _, ...]:
      result.insert(i+1, OperationType('*'));
    }
  }

  return result;
}