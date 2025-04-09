// elvira_icon.dart

enum ElviraIcon {
  elviraPaulo,
  elvira,
  nelson,
}

extension ElviraIconPath on ElviraIcon {
  String get path {
    switch (this) {
      case ElviraIcon.elviraPaulo:
        return 'assets/icons/Elvira_Paulo.png';
      case ElviraIcon.elvira:
        return 'assets/icons/Elvira.png';
      case ElviraIcon.nelson:
        return 'assets/icons/Nelson.png';
    }
  }
}
