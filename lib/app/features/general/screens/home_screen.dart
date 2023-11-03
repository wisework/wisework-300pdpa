import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/company_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/consent_form/consent_form_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/routes/consent_form_route.dart';
import 'package:pdpa/app/features/consent_management/user_consent/routes/user_consent_route.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/shared/drawers/bloc/drawer_bloc.dart';
import 'package:pdpa/app/shared/drawers/models/drawer_menu_models.dart';
import 'package:pdpa/app/shared/drawers/pdpa_drawer.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CompanyModel currentCompany;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    final bloc = context.read<SignInBloc>();

    String companyId = '';
    if (bloc.state is SignedInUser) {
      companyId = (bloc.state as SignedInUser).user.currentCompany;

      final companies = (bloc.state as SignedInUser).companies;
      currentCompany = companies.firstWhere(
        (company) => company.id == companyId,
        orElse: () => CompanyModel.empty(),
      );
    } else {
      currentCompany = CompanyModel.empty();
    }

    context
        .read<ConsentFormBloc>()
        .add(GetConsentFormsEvent(companyId: companyId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        shadowColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Theme.of(context).colorScheme.onBackground,
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        title: Image.asset(
          'assets/images/wisework-logo-mini.png', // เปลี่ยนเป็นที่อยู่ของไฟล์โลโก้ของคุณ
          height: 30, // ปรับความสูงตามที่คุณต้องการ
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Ionicons.menu_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            splashColor:
                Theme.of(context).colorScheme.surfaceTint.withOpacity(0.3),
          ),
        ),
      ),
      // AppBar(
      //   shadowColor: Theme.of(context).colorScheme.background,
      //   surfaceTintColor: Theme.of(context).colorScheme.onBackground,
      //   backgroundColor: Theme.of(context).colorScheme.onBackground,
      //   automaticallyImplyLeading: false,
      //   title: Row(
      //     mainAxisAlignment:
      //         MainAxisAlignment.start, // Align items to the start (left)
      //     children: <Widget>[
      //       InkWell(
      //         onTap: () {
      //           _scaffoldKey.currentState?.openDrawer();
      //         },
      //         splashColor:
      //             Theme.of(context).colorScheme.surfaceTint.withOpacity(0.3),
      //         borderRadius: BorderRadius.circular(8.0),
      //         child: Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: Icon(
      //             Ionicons.menu_outline,
      //             color: Theme.of(context).colorScheme.primary,
      //           ),
      //         ),
      //       ),
      //       Expanded(
      //         child: SizedBox(
      //           height: 50,
      //           width: 50,
      //           child: Image.asset(
      //             'assets/images/wisework-logo-mini.png',
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: SingleChildScrollView(
        child: BlocBuilder<SignInBloc, SignInState>(
          builder: (context, state) {
            if (state is SignedInUser) {
              return Column(
                children: [
                  const SizedBox(
                    height: UiConfig.textSpacing,
                  ),
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/3.png"),
                        fit: BoxFit
                            .fill, // Use BoxFit.cover to make the image fill the container without distorting the aspect ratio
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildGreetingUser(context),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: UiConfig.defaultPaddingSpacing,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: UiConfig.lineGap,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: UiConfig.defaultPaddingSpacing,
                              right: UiConfig.defaultPaddingSpacing),
                          child: Text(
                            tr('general.home.explore'),
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                        const SizedBox(height: UiConfig.lineSpacing),
                        _buildExplore(context),
                        const SizedBox(height: UiConfig.lineSpacing),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: UiConfig.lineGap,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: UiConfig.defaultPaddingSpacing,
                              right: UiConfig.defaultPaddingSpacing),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tr('general.home.recentlyUsed'),
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    context.push(
                                      ConsentFormRoute.consentForm.path,
                                    );
                                  },
                                  child: Text(
                                    tr('app.features.seeMore'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          decoration: TextDecoration.underline,
                                          decorationColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildRecentlyUsed(context),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: UiConfig.defaultPaddingSpacing,
                  ),
                ],
              );
            }
            return Text(
              tr('general.home.hello'),
              style: Theme.of(context).textTheme.titleMedium,
            );
          },
        ),
      ),
      drawer: PdpaDrawer(
        onClosed: () {
          _scaffoldKey.currentState?.closeDrawer();
        },
      ),
    );
  }

  Container _buildRecentlyUsed(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
      child: BlocBuilder<ConsentFormBloc, ConsentFormState>(
        builder: (context, state) {
          if (state is GotConsentForms) {
            return state.consentForms.isNotEmpty
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: min(3, state.consentForms.length),
                    itemBuilder: (context, index) {
                      return _buildItemCard(
                        context,
                        consentForm: state.consentForms[index],
                      );
                    },
                  )
                : Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: UiConfig.lineSpacing),
                        Image.asset(
                          'assets/images/4.png',
                        ),
                        Text(tr('app.features.resultNotFound'),
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: UiConfig.lineSpacing),
                        Text(tr('app.features.description'),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(
                          height: UiConfig.defaultPaddingSpacing,
                        ),
                      ],
                    ),
                  );
          }
          if (state is ConsentFormError) {
            return Center(
              child: Text(
                state.message,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  BlocBuilder _buildGreetingUser(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        if (state is SignedInUser) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: UiConfig.defaultPaddingSpacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          tr('general.home.welcome'),
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              state.user.firstName,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 8.0),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Icon(
                                Ionicons.sparkles,
                                color: Theme.of(context).colorScheme.onError,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Visibility(
                      visible: currentCompany.name.isNotEmpty,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: UiConfig.textSpacing),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              currentCompany.name,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return Text(
          tr('general.home.hello'),
          style: Theme.of(context).textTheme.titleMedium,
        );
      },
    );
  }

  BlocBuilder _buildExplore(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        if (state is SignedInUser) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (screenWidth <= 726)
                        // Display this when screen width is 600 or more
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 136,
                                  width: 200,
                                  child: InkWell(
                                    onTap: () {
                                      context.push(ConsentFormRoute
                                          .createConsentForm.path);
                                    },
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xff262626),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Icon(
                                                  Ionicons.add_circle_outline,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  tr('app.features.consent'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                Text(
                                                  tr('app.features.createcsf'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                SizedBox(
                                  height: 136,
                                  width: 200,
                                  child: InkWell(
                                    onTap: () {
                                      context.push(UserConsentRoute
                                          .userConsentScreen.path);
                                    },
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground, // Set your button color here
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xff262626),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Icon(
                                                  Ionicons.people_outline,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  tr('app.features.consent'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                Text(
                                                  tr('app.features.userconsents'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 136,
                                  width: 200,
                                  child: InkWell(
                                    onTap: () {
                                      context.push(
                                          ConsentFormRoute.consentForm.path);
                                    },
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground, // Set your button color here
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xff262626),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Icon(
                                                  Ionicons.clipboard_outline,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  tr('app.features.consent'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall, // Adjust the font size as needed
                                                ),
                                                Text(
                                                  tr('app.features.consentforms'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                SizedBox(
                                  height: 136,
                                  width: 200,
                                  child: InkWell(
                                    onTap: () {
                                      context.push(MasterDataRoute
                                          .purposesCategories.path);
                                    },
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground, // Set your button color here
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff262626),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(5.0),
                                                    child: Icon(
                                                      Ionicons.server_outline,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  tr('app.features.masterdata'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                Text(
                                                  tr('masterData.cm.purposeCategory.title'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      if (screenWidth >= 726)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  child: InkWell(
                                    onTap: () {
                                      context.push(ConsentFormRoute
                                          .createConsentForm.path);
                                    },
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xff262626),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Icon(
                                                  Ionicons.add_circle_outline,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  tr('app.features.consent'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                Text(
                                                  tr('app.features.createcsf'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                SizedBox(
                                  height: 136,
                                  width: 200,
                                  child: InkWell(
                                    onTap: () {
                                      context.push(UserConsentRoute
                                          .userConsentScreen.path);
                                    },
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground, // Set your button color here
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xff262626),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Icon(
                                                  Ionicons.people_outline,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  tr('app.features.consent'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                Text(
                                                  tr('app.features.userconsents'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                SizedBox(
                                  height: 136,
                                  width: 200,
                                  child: InkWell(
                                    onTap: () {
                                      context.push(
                                          ConsentFormRoute.consentForm.path);
                                    },
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground, // Set your button color here
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xff262626),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Icon(
                                                  Ionicons.clipboard_outline,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  tr('app.features.consent'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall, // Adjust the font size as needed
                                                ),
                                                Text(
                                                  tr('app.features.consentforms'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                SizedBox(
                                  height: 136,
                                  width: 200,
                                  child: InkWell(
                                    onTap: () {
                                      context.push(MasterDataRoute
                                          .purposesCategories.path);
                                    },
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground, // Set your button color here
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff262626),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(5.0),
                                                    child: Icon(
                                                      Ionicons.server_outline,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  tr('app.features.masterdata'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                Text(
                                                  tr('masterData.cm.purposeCategory.title'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              );
            },
          );
        }
        return Text(
          tr('general.home.hello'),
          style: Theme.of(context).textTheme.titleMedium,
        );
      },
    );
  }

  Column _buildItemCard(
    BuildContext context, {
    required ConsentFormModel consentForm,
  }) {
    const language = 'en-US';

    final title = consentForm.title
        .firstWhere(
          (item) => item.language == language,
          orElse: () => const LocalizedModel.empty(),
        )
        .text;
    final dateConsentForm = DateFormat("dd.MM.yy").format(
      consentForm.updatedDate,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MaterialInkWell(
          onTap: () {
            context.push(
              ConsentFormRoute.consentFormDetail.path
                  .replaceFirst(':id', consentForm.id),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: UiConfig.defaultPaddingSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        title.isNotEmpty
                            ? title
                            : tr('general.home.thisDataIsNotStored'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Text(
                        dateConsentForm,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: consentForm.purposeCategories.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: UiConfig.textLineSpacing,
                    ),
                    child: Text(
                      consentForm.purposeCategories.first.title
                          .firstWhere(
                            (item) => item.language == language,
                            orElse: LocalizedModel.empty,
                          )
                          .text,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: UiConfig.defaultPaddingSpacing,
          ),
          child: SizedBox(
            height: UiConfig.defaultPaddingSpacing,
          ),
        ),
        // เพิ่ม Container สำหรับเงาด้านล่าง
        Container(
          margin:
              const EdgeInsets.only(top: 8.0), // ระยะทางของ Container จากด้านบน
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey, // สีของเงา
                offset: Offset(0, 4), // ตำแหน่งเงา (x, y)
                blurRadius: 8.0, // ขนาดของเงา
              ),
            ],
          ),
        ),
      ],
    );
  }
}
