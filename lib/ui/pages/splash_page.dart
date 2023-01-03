import 'package:ff_annotation_route_core/ff_annotation_route_core.dart';
import 'package:flutter/material.dart';
import 'package:mikan_flutter/internal/extension.dart';
import 'package:mikan_flutter/internal/screen.dart';
import 'package:mikan_flutter/mikan_flutter_routes.dart';
import 'package:mikan_flutter/topvars.dart';
import 'package:mikan_flutter/ui/fragments/bangumi_cover_scroll_list.dart';
import 'package:mikan_flutter/widget/ripple_tap.dart';

@FFRoute(
  name: "splash",
  routeName: "/splash",
)
@immutable
class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: lightSystemUiOverlayStyle,
      child: Scaffold(
        body: _buildSplash(context),
      ),
    );
  }

  Positioned _buildAppIcon(final BuildContext context) {
    bool to = false;
    void toHome(BuildContext context) {
      if (to) {
        return;
      }
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, Routes.home.name);
        to = true;
      });
    }

    return Positioned(
      left: 0,
      right: 0,
      bottom: 128.0 + Screens.navBarHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder(
            future: Future.delayed(const Duration(seconds: 8)),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                toHome(context);
              }
              return ScalableRippleTap(
                shape: const CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Image.asset(
                    "assets/mikan.png",
                    width: 108,
                  ),
                ),
                onTap: () {
                  toHome(context);
                },
              );
            },
          ),
          sizedBoxH4,
          Text(
            "蜜柑计划",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18.0,
              color: Colors.white.withOpacity(0.87),
              shadows: [
                Shadow(
                  offset: const Offset(1, 1),
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8.0,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSplash(final BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const Positioned.fill(child: BangumiCoverScrollListFragment()),
        _buildAppIcon(context)
      ],
    );
  }
}
