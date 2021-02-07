class McuPhase4 {
  List<Phase4> phase4;

  McuPhase4({this.phase4});

  McuPhase4.fromJson(Map<String, dynamic> json) {
    if (json['movies'] != null && json['series'] != null) {
      phase4 = List<Phase4>();
      json['movies'].forEach((value) {
        phase4.add(Phase4.fromJson(value));
      });
      json['series'].forEach((value) {
        phase4.add(Phase4.fromJson(value));
      });
    }
  }
}

class Phase4 {
  String title;
  String year;
  String url;

  Phase4({this.title, this.year, this.url});

  Phase4.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    year = json['year'];
    url = json['url'];
  }
}

List<Phase4> getPhase4Suggestions(String query, List<Phase4> phase4) {
  List<Phase4> matchedPhase4 = List();

  matchedPhase4.addAll(phase4);
  matchedPhase4.retainWhere(
      (phase4) => phase4.title.toLowerCase().contains(query.toLowerCase()));

  if (query == "") {
    return phase4;
  } else {
    return matchedPhase4;
  }
}
