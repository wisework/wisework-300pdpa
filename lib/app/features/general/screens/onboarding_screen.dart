import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  // int _currentIndex = 0;
  final controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkResponse(
          child: Ink(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              color: Theme.of(context).colorScheme.primary,
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () async {
                await UserPreferences.setBool(
                  AppPreferences.isFirstLaunch,
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
                  await UserPreferences.setBool(
                    AppPreferences.isFirstLaunch,
                    false,
                  ).then(
                      (_) => GoRouter.of(context).go(GeneralRoute.home.path));
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
      ),
      body: boardscreen(context),
    );
  }

  Widget boardscreen(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CarouselSlider(
            items: [
              buildDataSubjectRightNews(context),
              buildDarkModeNews(context),
              // buildBoard1(context),
              // buildBoard2(context),
            ],
            carouselController: controller,
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              enableInfiniteScroll: false,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                // setState(() {
                //   _currentIndex = index;
                // });
              },
            ),
          ),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: List.generate(
        //     2, // Change this to the number of screens
        //     (index) => Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: CircleAvatar(
        //         radius: 6,
        //         backgroundColor: _currentIndex == index
        //             ? Theme.of(context).colorScheme.primary
        //             : Theme.of(context)
        //                 .colorScheme
        //                 .onTertiary, // Change these colors as needed
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  ContentWrapper buildDataSubjectRightNews(BuildContext context) {
    return ContentWrapper(
      child: Column(
        children: [
          Flexible(
            child: Image.asset(
              'assets/images/general/dataSubjectRightNews.png',
              width: 700,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "จัดการคำร้องขอใช้สิทธิ์",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      "ให้คุณจัดการกับคำร้องขอใช้สิทธิ์ของ เจ้าของข้อมูลส่วนบุคคลได้ครบถ้วนตาม พ.ร.บ.ฯ มั่นใจ ครบถ้วนทุกขั้นตอนการจัดการที่ฟังก์ชันนี้ ได้แก่ การตรวจสอบคำร้อง การพิจารณาและ ดำเนินการ และดูการสรุปผลของแต่ละรายการได้ อีกทั้งมาพร้อมแบบฟอร์มการขอใช้สิทธิ์ที่สามารถ ส่งต่อให้กับเจ้าของข้อมูลได้อย่างสะดวก รวดเร็ว",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          height: 40.0,
                          width: 120,
                          onPressed: next,
                          child: Text(
                            tr('app.board.next'),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ContentWrapper buildDarkModeNews(BuildContext context) {
    return ContentWrapper(
      child: Column(
        children: [
          Flexible(
            child: Image.asset(
              'assets/images/general/darkModeNews.png',
              width: 700,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "โหมดกลางคืน",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      "ปรับปรุงประสบการณ์การใช้งานของคุณในสภาพแวดล้อมที่มีแสงน้อย โหมดกลางคืน (Dark mode) ที่เมนูการตั้งค่าระบบ พร้อมสร้างประสบการณ์ที่ดีสำหรับผู้ใช้งาน และไม่เป็นภาระต่อสุขภาพดวงตา",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          height: 40.0,
                          width: 120,
                          onPressed: next,
                          child: Text(
                            tr('app.board.getstared'),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  // ContentWrapper buildBoard1(BuildContext context) {
  //   return ContentWrapper(
  //     child: Column(
  //       children: [
  //         Flexible(
  //           child: Image.asset(
  //             'assets/images/consent_management/onboarding.png',
  //             width: 700,
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //         Expanded(
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Theme.of(context).colorScheme.background,
  //               borderRadius: const BorderRadius.only(
  //                 topLeft: Radius.circular(20),
  //                 topRight: Radius.circular(20),
  //               ),
  //             ),
  //             child: Padding(
  //               padding: const EdgeInsets.all(20),
  //               child: Column(
  //                 children: [
  //                   Text(
  //                     tr('app.features.consentmanagement'),
  //                     style: Theme.of(context).textTheme.titleLarge,
  //                   ),
  //                   const SizedBox(height: 16.0),
  //                   Text(
  //                     tr('app.board.description'),
  //                     style: Theme.of(context).textTheme.bodyMedium,
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   const Spacer(),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       CustomButton(
  //                         height: 40.0,
  //                         width: 120,
  //                         onPressed: next,
  //                         child: Text(
  //                           tr('app.board.next'),
  //                           style: TextStyle(
  //                             color: Theme.of(context).colorScheme.onPrimary,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // ContentWrapper buildBoard2(BuildContext context) {
  //   return ContentWrapper(
  //     child: Column(
  //       children: [
  //         Flexible(
  //           child: Image.asset(
  //             'assets/images/master_data/onboarding.png',
  //             width: 700,
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //         Expanded(
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Theme.of(context).colorScheme.background,
  //               borderRadius: const BorderRadius.only(
  //                 topLeft: Radius.circular(20),
  //                 topRight: Radius.circular(20),
  //               ),
  //             ),
  //             child: Padding(
  //               padding: const EdgeInsets.all(20),
  //               child: Column(
  //                 children: [
  //                   Text(
  //                     tr('app.features.masterdata'),
  //                     style: Theme.of(context).textTheme.titleLarge,
  //                   ),
  //                   const SizedBox(height: 16.0),
  //                   Text(
  //                     tr('app.board.decription2'),
  //                     style: Theme.of(context).textTheme.bodyMedium,
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   const Spacer(),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       CustomButton(
  //                         height: 40.0,
  //                         width: 120,
  //                         onPressed: () async {
  //                           await UserPreferences.setBool(
  //                             AppPreferences.isFirstLaunch,
  //                             false,
  //                           ).then((_) => GoRouter.of(context)
  //                               .go(GeneralRoute.home.path));
  //                         },
  //                         child: Text(
  //                           tr('app.board.getstared'),
  //                           style: TextStyle(
  //                             color: Theme.of(context).colorScheme.onPrimary,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void next() => controller.nextPage();

  void previous() => controller.previousPage();
}
