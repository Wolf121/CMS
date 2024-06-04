class MasjidTimingsResponse {
  int success;
  String message;
  List<Phase> dataArray;

  MasjidTimingsResponse({
    required this.success,
    required this.message,
    required this.dataArray,
  });

  factory MasjidTimingsResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataJsonArray = json['data_array'];
    List<Phase> dataArray =
        dataJsonArray.map((dataJson) => Phase.fromJson(dataJson)).toList();

    return MasjidTimingsResponse(
      success: json['success'],
      message: json['message'],
      dataArray: dataArray,
    );
  }
}

class Phase {
  String phase;
  List<Masjid> masjids;

  Phase({
    required this.phase,
    required this.masjids,
  });

  factory Phase.fromJson(Map<String, dynamic> json) {
    List<dynamic> masjidsJsonArray = json['masjids'];
    List<Masjid> masjids = masjidsJsonArray
        .map((masjidJson) => Masjid.fromJson(masjidJson))
        .toList();

    return Phase(
      phase: json['phase'],
      masjids: masjids,
    );
  }
}

class Masjid {
  String title;
  String? description;
  String timings;
  String banner;

  Masjid({
    required this.title,
    this.description,
    required this.timings,
    required this.banner,
  });

  factory Masjid.fromJson(Map<String, dynamic> json) {
    return Masjid(
      title: json['title'] ?? "N/A",
      description: json['description'] ?? "N/A",
      timings: json['timings'] ?? "N/A",
      banner: json['banner'] ?? 'N/A',
    );
  }
}
