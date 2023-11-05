import 'package:twopp/src/token.dart';

class AST {
  Token value;
  List<AST> children;

  AST(this.value) : children = [];

  addChild(AST child) => children.add(child);
}

AST createAST(List<Token> tokens){
  int bracketLlv = 0;
  List<({int index, int priority})> oprPriorities = [];

  if (tokens.isEmpty){
    throw Exception("AST error :(");
  }

  if (tokens.length == 1){
    if (tokens.first is NumberType){
      return AST(tokens.first);
    }else{
      throw Exception("AST error :(");
    }
  }
  
  for (int i = 0; i < tokens.length; i++){
    if (bracketLlv.isNegative) throw Exception("AST error :(");
    
    switch(tokens[i]){
      case BracketOpen  _: bracketLlv++;
      case BracketClose _: bracketLlv--;
      case OperationType(priority: var pr): {
        if (bracketLlv == 0) {
          oprPriorities.add((
              index: i,
              priority: pr,
          ));
        }
      }
    }
  }

  if (bracketLlv != 0) {
    throw Exception("AST error :(");
  }

  if (oprPriorities.isEmpty){
    if (tokens.first is BracketOpen && tokens.last is BracketClose){
      return createAST(tokens.sublist(1, tokens.length-1));
    }else if (tokens.first is FunctionType){
      var res = AST(tokens.first);
      res.addChild(createAST(tokens.sublist(1)));
      return res;
    }
    throw Exception("AST error :(");
  }
  
  oprPriorities.sort((a, b) => a.priority.compareTo(b.priority));

  var res = AST(tokens[oprPriorities.first.index]);
  res.addChild(createAST((tokens.sublist(0, oprPriorities.first.index))));
  res.addChild(createAST((tokens.sublist(oprPriorities.first.index+1))));

  return res;
}