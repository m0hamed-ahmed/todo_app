extension IntegerExtension on dynamic {
  String addZeroFormat() {
    if(int.parse('$this') <= 9) {return '0$this';}
    else {return '$this';}
  }

  String convertHourToFormat12() {
    if(int.parse('$this') > 12) {return '${int.parse('$this') - 12}';}
    else if(int.parse('$this') == 0) {return '12';}
    else {return '$this';}
  }
}