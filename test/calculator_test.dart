import 'package:flutter_test/flutter_test.dart';

import 'package:twopp/calculator.dart';

void main() {
  test('adds one to input values', () {
    expect(calculates("2+2*2"), 6);
  });
}
