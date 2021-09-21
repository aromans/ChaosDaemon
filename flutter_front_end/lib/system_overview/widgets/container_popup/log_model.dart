class Log {
  String timeStamp;
  String body;
  int level;

  String? highlightedSection;

  Log({
    required this.timeStamp,
    required this.body,
    required this.level,
  });

  void printObject() {
    print(this.body);
  }  
}
