// GENERATED CODE - DO NOT MODIFY MANUALLY
// **************************************************************************
// Auto generated by https://github.com/fluttercandies/ff_annotation_route
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:mikan_flutter/model/record_item.dart';
import 'package:mikan_flutter/model/season.dart';
import 'package:mikan_flutter/model/season_gallery.dart';
import 'package:mikan_flutter/model/subgroup.dart';
import 'package:mikan_flutter/model/year_season.dart';

const List<String> routeNames = <String>[
  'bangumi',
  'forget-password',
  'home',
  'login',
  'recent-subscribed',
  'record-detail',
  'register',
  'season',
  'season-list',
  'splash',
  'subgroup',
  'subscribed-season',
];

class Routes {
  const Routes._();

  /// '/bangumi'
  ///
  /// [name] : 'bangumi'
  ///
  /// [routeName] : '/bangumi'
  ///
  /// [constructors] :
  ///
  /// BangumiPage : [Key? key, String(required) bangumiId, String(required) cover, String(required) heroTag]
  static const _Bangumi bangumi = _Bangumi();

  /// '/forget-password'
  ///
  /// [name] : 'forget-password'
  ///
  /// [routeName] : '/forget-password'
  static const String forgetPassword = 'forget-password';

  /// '/'
  ///
  /// [name] : 'home'
  ///
  /// [routeName] : '/'
  static const String home = 'home';

  /// '/login'
  ///
  /// [name] : 'login'
  ///
  /// [routeName] : '/login'
  static const String login = 'login';

  /// '/recent-subscribed'
  ///
  /// [name] : 'recent-subscribed'
  ///
  /// [routeName] : '/recent-subscribed'
  ///
  /// [constructors] :
  ///
  /// RecentSubscribedPage : [Key? key, List<RecordItem>(required) loaded]
  static const _RecentSubscribed recentSubscribed = _RecentSubscribed();

  /// '/record-detail'
  ///
  /// [name] : 'record-detail'
  ///
  /// [routeName] : '/record-detail'
  ///
  /// [constructors] :
  ///
  /// RecordDetailPage : [Key? key, String(required) url]
  static const _RecordDetail recordDetail = _RecordDetail();

  /// '/register'
  ///
  /// [name] : 'register'
  ///
  /// [routeName] : '/register'
  static const String register = 'register';

  /// '/season'
  ///
  /// [name] : 'season'
  ///
  /// [routeName] : '/season'
  ///
  /// [constructors] :
  ///
  /// SingleSeasonPage : [Key? key, Season(required) season]
  static const _Season season = _Season();

  /// '/season-list'
  ///
  /// [name] : 'season-list'
  ///
  /// [routeName] : '/season-list'
  ///
  /// [constructors] :
  ///
  /// SeasonListPage : [Key? key, List<YearSeason>(required) years]
  static const _SeasonList seasonList = _SeasonList();

  /// '/splash'
  ///
  /// [name] : 'splash'
  ///
  /// [routeName] : '/splash'
  ///
  /// [constructors] :
  ///
  /// SplashPage : []
  static const String splash = 'splash';

  /// '/subgroup'
  ///
  /// [name] : 'subgroup'
  ///
  /// [routeName] : '/subgroup'
  ///
  /// [constructors] :
  ///
  /// SubgroupPage : [Key? key, Subgroup(required) subgroup]
  static const _Subgroup subgroup = _Subgroup();

  /// '/subscribed-season'
  ///
  /// [name] : 'subscribed-season'
  ///
  /// [routeName] : '/subscribed-season'
  ///
  /// [constructors] :
  ///
  /// SubscribedSeasonPage : [Key? key, List<YearSeason>(required) years, List<SeasonGallery>(required) galleries]
  static const _SubscribedSeason subscribedSeason = _SubscribedSeason();
}

class _Bangumi {
  const _Bangumi();

  String get name => 'bangumi';

  Map<String, dynamic> d(
          {Key? key,
          required String bangumiId,
          required String cover,
          required String heroTag}) =>
      <String, dynamic>{
        'key': key,
        'bangumiId': bangumiId,
        'cover': cover,
        'heroTag': heroTag,
      };

  @override
  String toString() => name;
}

class _RecentSubscribed {
  const _RecentSubscribed();

  String get name => 'recent-subscribed';

  Map<String, dynamic> d({Key? key, required List<RecordItem> loaded}) =>
      <String, dynamic>{
        'key': key,
        'loaded': loaded,
      };

  @override
  String toString() => name;
}

class _RecordDetail {
  const _RecordDetail();

  String get name => 'record-detail';

  Map<String, dynamic> d({Key? key, required String url}) => <String, dynamic>{
        'key': key,
        'url': url,
      };

  @override
  String toString() => name;
}

class _Season {
  const _Season();

  String get name => 'season';

  Map<String, dynamic> d({Key? key, required Season season}) =>
      <String, dynamic>{
        'key': key,
        'season': season,
      };

  @override
  String toString() => name;
}

class _SeasonList {
  const _SeasonList();

  String get name => 'season-list';

  Map<String, dynamic> d({Key? key, required List<YearSeason> years}) =>
      <String, dynamic>{
        'key': key,
        'years': years,
      };

  @override
  String toString() => name;
}

class _Subgroup {
  const _Subgroup();

  String get name => 'subgroup';

  Map<String, dynamic> d({Key? key, required Subgroup subgroup}) =>
      <String, dynamic>{
        'key': key,
        'subgroup': subgroup,
      };

  @override
  String toString() => name;
}

class _SubscribedSeason {
  const _SubscribedSeason();

  String get name => 'subscribed-season';

  Map<String, dynamic> d(
          {Key? key,
          required List<YearSeason> years,
          required List<SeasonGallery> galleries}) =>
      <String, dynamic>{
        'key': key,
        'years': years,
        'galleries': galleries,
      };

  @override
  String toString() => name;
}
