import 'dart:math';

class RandomLogMessageGenerator {
  Random _rnd = Random();
  String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';

  String getRandomString(int length) {
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => _chars.codeUnitAt(
          _rnd.nextInt(_chars.length),
        ),
      ),
    );
  }

  bool checkSpaceEdgeCases(int spaceVal, int sentenceLen) {
    if (spaceVal == 0 || spaceVal == sentenceLen-1) {
      return false;
    } else {
      return true;
    }
  }

  String replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) +
        newChar +
        oldString.substring(index + 1);
  }

  bool checkSpaceValidity(List<int> spaceList, int sentenceLen) {
    bool _valid = true;
    int l1Distance;

    // single value case
    if (spaceList.length == 1) {
      return checkSpaceEdgeCases(spaceList[0], sentenceLen);
    }

    //multi-value case
    for (int i = 0; i < spaceList.length; i++) {
      if (checkSpaceEdgeCases(spaceList[i], sentenceLen) == false) {
        _valid = false;
      }
      //first element
      if (i == 0) {
        l1Distance = (spaceList[i + 1] - spaceList[i]).abs();
        if (spaceList[i + 1] == spaceList[i] || l1Distance < 2) {
          _valid = false;
        }
      }
      //last element
      else if (i == spaceList.length - 1) {
        l1Distance = (spaceList[i - 1] - spaceList[i]).abs();
        if (spaceList[i - 1] == spaceList[i] || l1Distance < 2) {
          _valid = false;
        }
      }
      //interior elements
      else if (spaceList.length > 3) {
        if (spaceList[i - 1] == spaceList[i] ||
            spaceList[i + 1] == spaceList[i]) {
          _valid == false;
        }
        l1Distance = (spaceList[i - 1] - spaceList[i]).abs();
        if (l1Distance < 2) {
          _valid = false;
        }
        l1Distance = (spaceList[i + 1] - spaceList[i]).abs();
        if (l1Distance < 2) {
          _valid = false;
        }
      }
    }
    return _valid;
  }

  String generate(int len) {
    if (len < 5) {
      return getRandomString(len);
    }
    int _breakPoint = 1;
    for (int i = 1; i <= len; i++) {
      if (len / i < 5) {
        _breakPoint = i;
        break;
      }
    }

    int _numOfWords = Random().nextInt(_breakPoint);
    if (_numOfWords == 0) {
      _numOfWords = 1;
    }
    List<int> _spaces = [];
    bool _validSpacePlacement;
    // last word has no space
    for (int i = 0; i < _numOfWords; i++) {
      _validSpacePlacement = false;
      while (_validSpacePlacement == false) {
        _spaces.add(Random().nextInt(len));
        _validSpacePlacement = checkSpaceValidity(_spaces, len);
        if (_validSpacePlacement == false) {
          _spaces.removeLast();
        }
      }
    }

    String sentence = getRandomString(len);
    for (int i = 0; i < _spaces.length; i++) {
      sentence = replaceCharAt(sentence, _spaces[i], ' ');
    }

    return sentence;
  }
}
