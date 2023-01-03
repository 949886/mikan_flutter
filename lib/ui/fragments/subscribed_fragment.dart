import 'dart:math' as math;

import 'package:extended_sliver/extended_sliver.dart';
import 'package:flutter/material.dart';
import 'package:mikan_flutter/internal/delegate.dart';
import 'package:mikan_flutter/internal/extension.dart';
import 'package:mikan_flutter/internal/image_provider.dart';
import 'package:mikan_flutter/internal/screen.dart';
import 'package:mikan_flutter/mikan_flutter_routes.dart';
import 'package:mikan_flutter/model/bangumi.dart';
import 'package:mikan_flutter/model/record_item.dart';
import 'package:mikan_flutter/model/season_gallery.dart';
import 'package:mikan_flutter/providers/op_model.dart';
import 'package:mikan_flutter/providers/subscribed_model.dart';
import 'package:mikan_flutter/topvars.dart';
import 'package:mikan_flutter/ui/components/rss_record_item.dart';
import 'package:mikan_flutter/ui/fragments/bangumi_sliver_grid_fragment.dart';
import 'package:mikan_flutter/ui/fragments/index_fragment.dart';
import 'package:mikan_flutter/widget/icon_button.dart';
import 'package:mikan_flutter/widget/ripple_tap.dart';
import 'package:mikan_flutter/widget/sliver_pinned_header.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sliver_tools/sliver_tools.dart';

@immutable
class SubscribedFragment extends StatelessWidget {
  const SubscribedFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AnnotatedRegion(
      value: context.fitSystemUiOverlayStyle,
      child: Scaffold(
        body: _buildSubscribedView(context, theme),
      ),
    );
  }

  Widget _buildSubscribedView(
    BuildContext context,
    ThemeData theme,
  ) {
    final subscribedModel =
        Provider.of<SubscribedModel>(context, listen: false);
    return SmartRefresher(
      header: WaterDropMaterialHeader(
        backgroundColor: theme.secondary,
        color: theme.secondary.isDark ? Colors.white : Colors.black,
        distance: Screens.statusBarHeight + 42.0,
      ),
      controller: subscribedModel.refreshController,
      enablePullDown: true,
      enablePullUp: false,
      onRefresh: subscribedModel.refresh,
      child: CustomScrollView(
        slivers: [
          _buildHeader(),
          MultiSliver(
            pushPinnedChildren: true,
            children: [
              _buildRssSection(context, theme),
              _buildRssList(theme, subscribedModel),
            ],
          ),
          MultiSliver(
            pushPinnedChildren: true,
            children: [
              _buildSeasonRssSection(theme, subscribedModel),
              _buildSeasonRssList(theme, subscribedModel),
            ],
          ),
          MultiSliver(
            pushPinnedChildren: true,
            children: [
              _buildRssRecordsSection(context, theme),
              _buildRssRecordsList(theme),
            ],
          ),
          _buildSeeMore(theme, subscribedModel),
          sliverSizedBoxH80WithNavBarHeight,
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const _PinedHeader();
  }

  Widget _buildSeasonRssList(
    final ThemeData theme,
    final SubscribedModel subscribedModel,
  ) {
    return Selector<SubscribedModel, List<Bangumi>?>(
      selector: (_, model) => model.bangumis,
      shouldRebuild: (pre, next) => pre.ne(next),
      builder: (context, bangumis, __) {
        if (subscribedModel.seasonLoading) {
          return SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              height: 240.0,
              margin: edgeH16B16,
              padding: edge24,
              decoration: BoxDecoration(
                color: theme.backgroundColor.withOpacity(0.87),
              ),
              child: centerLoading,
            ),
          );
        }
        if (bangumis.isNullOrEmpty) {
          return SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              margin: edgeH16B16,
              padding: edge28,
              decoration: BoxDecoration(
                color: theme.backgroundColor.withOpacity(0.87),
              ),
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/mikan.png",
                      width: 64.0,
                    ),
                    sizedBoxH12,
                    const Text(
                      "本季度您还没有订阅任何番组哦\n快去添加订阅吧",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return BangumiSliverGridFragment(
          flag: "subscribed",
          bangumis: bangumis!,
          padding: edgeH16B16,
          handleSubscribe: (bangumi, flag) {
            context.read<OpModel>().subscribeBangumi(
              bangumi.id,
              bangumi.subscribed,
              onSuccess: () {
                bangumi.subscribed = !bangumi.subscribed;
                context.read<OpModel>().subscribeChanged(flag);
              },
              onError: (msg) {
                "订阅失败：$msg".toast();
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSeasonRssSection(
    final ThemeData theme,
    final SubscribedModel subscribedModel,
  ) {
    return SliverPinnedToBoxAdapter(
      child: Transform.translate(
        offset: offsetY_1,
        child: Container(
          color: theme.scaffoldBackgroundColor,
          padding: edgeH16V8,
          child: Selector<SubscribedModel, List<Bangumi>?>(
              selector: (_, model) => model.bangumis,
              builder: (context, bangumis, _) {
                final hasVal = bangumis.isSafeNotEmpty;
                final updateNum =
                    bangumis?.where((e) => e.num != null && e.num! > 0).length;
                return Row(
                  children: [
                    const Expanded(
                      child: Text("季度订阅", style: textStyle18B),
                    ),
                    if (hasVal)
                      Tooltip(
                        message: [
                          if (updateNum! > 0) "最近有更新 $updateNum部",
                          "本季度共订阅 ${bangumis!.length}部"
                        ].join("，"),
                        child: Text(
                          [
                            if (updateNum > 0) "🚀 $updateNum部",
                            "🎬 ${bangumis.length}部"
                          ].join("，"),
                          style: theme.textTheme.caption,
                        ),
                      ),
                    sizedBoxW16,
                    if (hasVal)
                      RightArrowButton(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.subscribedSeason.name,
                            arguments: Routes.subscribedSeason.d(
                              years: subscribedModel.years ?? [],
                              galleries: [
                                SeasonGallery(
                                  year: subscribedModel.season!.year,
                                  season: subscribedModel.season!.season,
                                  title: subscribedModel.season!.title,
                                  bangumis: subscribedModel.bangumis ?? [],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget _buildRssSection(
    final BuildContext context,
    final ThemeData theme,
  ) {
    return SliverPinnedToBoxAdapter(
      child: Transform.translate(
        offset: offsetY_1,
        child: Container(
          color: theme.scaffoldBackgroundColor,
          padding: edgeH16V8,
          child: Selector<SubscribedModel, Map<String, List<RecordItem>>?>(
              selector: (_, model) => model.rss,
              builder: (context, rss, child) {
                final isEmpty = rss.isNullOrEmpty;
                return Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "最近更新",
                        style: textStyle18B,
                      ),
                    ),
                    if (!isEmpty)
                      Tooltip(
                        message: "最近三天共有${rss!.length}部订阅更新",
                        child: Text(
                          "🚀 ${rss.length}部",
                          style: theme.textTheme.caption,
                        ),
                      ),
                    sizedBoxW16,
                    if (!isEmpty)
                      RightArrowButton(
                        onTap: () {
                          _toRecentSubscribedPage(context);
                        },
                      ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget _buildRssList(
    final ThemeData theme,
    final SubscribedModel subscribedModel,
  ) {
    return Selector<SubscribedModel, Map<String, List<RecordItem>>?>(
      selector: (_, model) => model.rss,
      shouldRebuild: (pre, next) => pre.ne(next),
      builder: (_, rss, __) {
        if (subscribedModel.recordsLoading) {
          return SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              height: 120.0,
              margin: edgeH16B16,
              padding: edge24,
              decoration: BoxDecoration(
                color: theme.backgroundColor.withOpacity(0.87),
              ),
              child: centerLoading,
            ),
          );
        }
        if (rss.isSafeNotEmpty) {
          final entries = rss!.entries.toList(growable: false);
          return SliverPadding(
            padding: edgeH16B16,
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 108.0,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.64,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildRssListItemCover(context, entries[index]);
                },
                childCount: entries.length,
              ),
            ),
          );
        }
        return SliverToBoxAdapter(
          child: Container(
            width: double.infinity,
            margin: edgeH16B16,
            padding: edge24,
            decoration: BoxDecoration(color: theme.backgroundColor),
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    "assets/mikan.png",
                    width: 64.0,
                  ),
                  sizedBoxH12,
                  const Text(
                    "您的订阅中最近三天还没有更新内容哦\n快去添加订阅吧",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _toRecentSubscribedPage(final BuildContext context) {
    Navigator.pushNamed(
      context,
      Routes.recentSubscribed.name,
      arguments: Routes.recentSubscribed
          .d(loaded: context.read<SubscribedModel>().records ?? []),
    );
  }

  Widget _buildRssListItemCover(
    final BuildContext context,
    final MapEntry<String, List<RecordItem>> entry,
  ) {
    final List<RecordItem> records = entry.value;
    final int recordsLength = records.length;
    final String bangumiCover = records[0].cover;
    final String bangumiId = entry.key;
    final String badge = recordsLength > 99 ? "99+" : "+$recordsLength";
    final String currFlag = "rss:$bangumiId:$bangumiCover";
    final imageProvider = CacheImageProvider(bangumiCover);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ScalableRippleTap(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.bangumi.name,
                arguments: Routes.bangumi.d(
                  heroTag: currFlag,
                  bangumiId: bangumiId,
                  cover: bangumiCover,
                ),
              );
            },
            child: Stack(
              fit: StackFit.loose,
              clipBehavior: Clip.antiAlias,
              children: [
                Positioned.fill(
                  child: Hero(
                    tag: currFlag,
                    child: Image(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      loadingBuilder: (_, child, event) {
                        return event == null
                            ? child
                            : Padding(
                                padding: edge16,
                                child: Center(
                                  child: Image.asset(
                                    "assets/mikan.png",
                                  ),
                                ),
                              );
                      },
                      errorBuilder: (_, __, ___) {
                        return Padding(
                          padding: edge16,
                          child: Center(
                            child: Image.asset(
                              "assets/mikan.png",
                              colorBlendMode: BlendMode.color,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  right: -10,
                  top: 4,
                  child: Transform.rotate(
                    angle: math.pi / 4.0,
                    child: Container(
                      width: 42.0,
                      color: Colors.redAccent,
                      child: Text(
                        badge,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        sizedBoxH8,
        Tooltip(
          message: records.first.name,
          child: Text(
            records.first.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle14B500,
          ),
        )
      ],
    );
  }

  Widget _buildRssRecordsSection(
    final BuildContext context,
    final ThemeData theme,
  ) {
    return Selector<SubscribedModel, List<RecordItem>?>(
      selector: (_, model) => model.records,
      shouldRebuild: (pre, next) => pre.ne(next),
      builder: (_, records, __) {
        if (records.isNullOrEmpty) return emptySliverToBoxAdapter;
        return SliverPinnedToBoxAdapter(
          child: Transform.translate(
            offset: offsetY_1,
            child: Container(
              color: theme.scaffoldBackgroundColor,
              padding: edgeH16V8,
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "更新列表",
                      style: textStyle18B,
                    ),
                  ),
                  RightArrowButton(
                    onTap: () {
                      _toRecentSubscribedPage(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRssRecordsList(final ThemeData theme) {
    return SliverPadding(
      padding: edgeH16B16,
      sliver: Selector<SubscribedModel, List<RecordItem>?>(
        selector: (_, model) => model.records,
        shouldRebuild: (pre, next) => pre.ne(next),
        builder: (_, records, __) {
          if (records.isNullOrEmpty) {
            return emptySliverToBoxAdapter;
          }
          return SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final record = records![index];
                return RssRecordItem(
                  index: index,
                  record: record,
                  theme: theme,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.recordDetail.name,
                      arguments: Routes.recordDetail.d(url: record.url),
                    );
                  },
                );
              },
              childCount: records!.length,
            ),
            gridDelegate: const SliverGridDelegateWithMinCrossAxisExtent(
              minCrossAxisExtent: 400.0,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              mainAxisExtent: 150.0,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSeeMore(
    final ThemeData theme,
    final SubscribedModel subscribedModel,
  ) {
    return Selector<SubscribedModel, int>(
      builder: (context, length, _) {
        if (length == 0) {
          return emptySliverToBoxAdapter;
        }
        return SliverToBoxAdapter(
          child: Padding(
            padding: edge16,
            child: TextButton(
              onPressed: () {
                _toRecentSubscribedPage(context);
              },
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  color: theme.secondary,
                ),
                shadowColor: theme.secondary.withOpacity(0.87),
              ),
              child: const Text("查看更多"),
            ),
          ),
        );
      },
      shouldRebuild: (pre, next) => pre != next,
      selector: (_, model) => model.records?.length ?? 0,
    );
  }
}

class _PinedHeader extends StatelessWidget {
  const _PinedHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final it = ColorTween(
      begin: theme.backgroundColor,
      end: theme.scaffoldBackgroundColor,
    );
    return StackSliverPinnedHeader(
      childrenBuilder: (context, ratio) {
        final ic = it.transform(ratio);
        return [
          Positioned(
            right: 0,
            top: 12.0 + Screens.statusBarHeight,
            child: SmallCircleButton(
              onTap: () {
                showSettingsPanel(context);
              },
              color: ic,
              icon: Icons.tune_rounded,
            ),
          ),
          Positioned(
            top: 78.0 * (1 - ratio) + 18.0 + Screens.statusBarHeight,
            left: 0,
            child: Text(
              "我的订阅",
              style: TextStyle(
                fontSize: 24.0 - (ratio * 4.0),
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
          ),
        ];
      },
    );
  }
}
