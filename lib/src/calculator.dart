import 'package:twopp/src/ast.dart';
import 'package:twopp/src/lexer.dart';
import 'package:twopp/src/token.dart';

num? calculates(String arg){
  try {
    return _calculates(createAST(lexer(arg)));
  } catch (e) {
    return null;
  }
}

num _calculates(AST tree) => switch (tree.value) {
  OperationType(operation: var opr) => opr(
    _calculates(tree.children[0]),
    _calculates(tree.children[1])
  ),
  FunctionType(function: var fn) => fn(
    _calculates(tree.children.first)
  ),
  NumberType(value: var val) => val,
  _=> throw Exception("Calculates error :("),
};