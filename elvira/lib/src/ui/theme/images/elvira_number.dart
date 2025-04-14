// elvira_number.dart

enum ElviraNumber {
  zero,
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  dot,
}

extension ElviraNumberPath on ElviraNumber {
  String get path {
    switch (this) {
      case ElviraNumber.zero:
        return 'assets/fonts/numbers/0.png';
      case ElviraNumber.one:
        return 'assets/fonts/numbers/1.png';
      case ElviraNumber.two:
        return 'assets/fonts/numbers/2.png';
      case ElviraNumber.three:
        return 'assets/fonts/numbers/3.png';
      case ElviraNumber.four:
        return 'assets/fonts/numbers/4.png';
      case ElviraNumber.five:
        return 'assets/fonts/numbers/5.png';
      case ElviraNumber.six:
        return 'assets/fonts/numbers/6.png';
      case ElviraNumber.seven:
        return 'assets/fonts/numbers/7.png';
      case ElviraNumber.eight:
        return 'assets/fonts/numbers/8.png';
      case ElviraNumber.nine:
        return 'assets/fonts/numbers/9.png';
      case ElviraNumber.dot:
        return 'assets/fonts/numbers/dot.png';
    }
  }
}
