// elvira_image.dart
enum ElviraImage { elviraPortrait, nelsonStanding, pauloPortrait,  }

extension ElviraImagePath on ElviraImage {
  String get path {
    switch (this) {
      case ElviraImage.elviraPortrait:
        return 'assets/images/personagens/elvira/Elvira_Portrait.png';
      case ElviraImage.nelsonStanding:
        return 'assets/images/personagens/nelson/Nelson_Standing_Tablet.png';
      case ElviraImage.pauloPortrait:
        return 'assets/images/personagens/paulo/Paulo_Portrait.png';
   
    }
  }
}
