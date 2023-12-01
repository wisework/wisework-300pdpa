import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/general/routes/general_route.dart';
import 'package:pdpa/app/shared/utils/user_preferences.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = CarouselController();

  final int pageLength = 3;
  int pageIndex = 0;

  void _onNextPressed() {
    if (pageIndex < (pageLength - 1)) {
      setState(() {
        pageIndex += 1;
      });
    }

    controller.nextPage();
  }

  Future<void> _onStartPressed() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;

    await UserPreferences.setBool(
      version,
      false,
    ).then((_) => GoRouter.of(context).go(GeneralRoute.home.path));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildOnBoardingScreens(
        context,
        screenSize: screenSize,
      ),
      backgroundColor: pageIndex == 2
          ? const Color(0xFF08101F)
          : Theme.of(context).colorScheme.onBackground,
      extendBodyBehindAppBar: true,
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: InkResponse(
        child: Ink(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () async {
              final packageInfo = await PackageInfo.fromPlatform();
              final version = packageInfo.version;

              await UserPreferences.setBool(
                version,
                false,
              ).then((_) => GoRouter.of(context).go(GeneralRoute.home.path));
            },
          ),
        ),
      ),
      actions: [
        InkResponse(
          child: Ink(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () async {
                final packageInfo = await PackageInfo.fromPlatform();
                final version = packageInfo.version;

                await UserPreferences.setBool(
                  version,
                  false,
                ).then((_) => GoRouter.of(context).go(GeneralRoute.home.path));
              },
              child: Text(
                tr('app.board.skip'),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
        ),
      ],
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  SizedBox _buildOnBoardingScreens(
    BuildContext context, {
    required Size screenSize,
  }) {
    return SizedBox(
      height: screenSize.height,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: ContentWrapper(
              child: CarouselSlider(
                items: <Widget>[
                  Image.asset(
                    'assets/images/general/onboarding_1.png',
                    fit: BoxFit.cover,
                  ),
                  Image.asset(
                    'assets/images/general/onboarding_2.png',
                    width: 700,
                    fit: BoxFit.cover,
                  ),
                  Transform.translate(
                    offset: const Offset(0.1, 0),
                    child: Transform.scale(
                      scaleX: 1.1,
                      child: Image.asset(
                        'assets/images/general/darkModeNews.png',
                        width: 700,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
                carouselController: controller,
                options: CarouselOptions(
                  height: screenSize.height,
                  enableInfiniteScroll: false,
                  viewportFraction: 1.0,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: [
              _buildOnBoardingInfo(
                context,
                title: tr("dataSubjectRight.manageRequests"),
                description: tr("app.board.description"),
                onButtonPressed: _onNextPressed,
              ),
              _buildOnBoardingInfo(
                context,
                title: tr("dataSubjectRight.manageRequests"),
                description: tr("app.board.decription2"),
                onButtonPressed: _onNextPressed,
              ),
              _buildOnBoardingInfo(
                context,
                title: tr("app.mode"),
                description: tr("app.board.decription4"),
                buttonText: tr('app.board.getstared'),
                onButtonPressed: _onStartPressed,
              ),
            ].elementAt(pageIndex),
          ),
        ],
      ),
    );
  }

  ContentWrapper _buildOnBoardingInfo(
    BuildContext context, {
    required String title,
    String? description,
    String? buttonText,
    required VoidCallback onButtonPressed,
  }) {
    return ContentWrapper(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.outline,
              blurRadius: 4.0,
              offset: const Offset(0, -2.0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            UiConfig.defaultPaddingSpacing * 2,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (description != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: UiConfig.lineSpacing,
                          ),
                          child: Text(
                            description,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              CustomButton(
                height: 40.0,
                margin: const EdgeInsets.only(
                  top: UiConfig.lineSpacing,
                ),
                onPressed: onButtonPressed,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      buttonText ?? tr('app.board.next'),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
