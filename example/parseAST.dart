import 'dart:io';

import 'package:graph_dot/graph_dot.dart';
import 'package:twopp/calculator.dart';


void main() {
  var g = Graph.parseTree(createAST(lexer("sin(2*PI-2)*4-2/3")));

  File newFile = File("./test.dot");

  newFile.writeAsStringSync(g.toDot());

  Process.runSync("dot", ["-Tpng", "-Gdpi=600", "test.dot", "-o", "test.png"]);
}