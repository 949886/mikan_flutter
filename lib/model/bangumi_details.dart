import 'package:mikan_flutter/model/subgroup_bangumi.dart';

class BangumiDetails {
  String id;
  String cover;
  String name;
  bool subscribed;
  Map<String, String> more;
  String intro;
  List<SubgroupBangumi> subgroupBangumis;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BangumiDetails &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          cover == other.cover &&
          name == other.name &&
          subscribed == other.subscribed &&
          more == other.more &&
          intro == other.intro &&
          subgroupBangumis == other.subgroupBangumis;

  @override
  int get hashCode =>
      id.hashCode ^
      cover.hashCode ^
      name.hashCode ^
      subscribed.hashCode ^
      more.hashCode ^
      intro.hashCode ^
      subgroupBangumis.hashCode;
}
