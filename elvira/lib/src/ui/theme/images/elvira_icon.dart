// elvira_icon.dart

enum ElviraIcon {
  elviraPaulo,
  elvira,
  nelson,
  cogwheel,
  medicine,
  emergency,
  phone,
  elviraGolden,
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
      case ElviraIcon.cogwheel:
        return 'assets/icons/cogwheel.png';
      case ElviraIcon.medicine:
        return 'assets/icons/medicine.png';
      case ElviraIcon.emergency:
        return 'assets/icons/emergency.png';
      case ElviraIcon.phone:
        return 'assets/icons/phone.png';
      case ElviraIcon.elviraGolden:
        return 'assets/icons/Elvira_Goldenrod.png';
    }
  }
}
