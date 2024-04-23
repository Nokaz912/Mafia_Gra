import 'package:mobile/models/VotingResult.dart';

class VotingSummary {
  final List<VotingResult> results;

  VotingSummary({
    required this.results
  });

  factory VotingSummary.fromJson(Map<String, dynamic> json) {
    List<dynamic> resultsJson = json['results'];
    return VotingSummary(
      results: resultsJson.map((resultJson) => VotingResult.fromJson(resultJson)).toList()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results
    };
  }
}
