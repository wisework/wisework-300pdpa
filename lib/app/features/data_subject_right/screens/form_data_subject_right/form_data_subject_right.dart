import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';

import 'package:pdpa/app/data/models/data_subject_right/requester_verification_model.dart';

import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';

import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/data/presets/reason_types_preset.dart';
import 'package:pdpa/app/data/presets/request_types_preset.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/data_subject_right/bloc/form_data_sub_ject_right/form_data_sub_ject_right_bloc.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/form_data_subject_right/form_data_subject_right_cubit.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/features/data_subject_right/screens/form_data_subject_right/pages/acknowledge_page.dart';
import 'package:pdpa/app/features/data_subject_right/screens/form_data_subject_right/pages/data_owner_detail_page.dart';
import 'package:pdpa/app/features/data_subject_right/screens/form_data_subject_right/pages/identity_verification_page.dart';
import 'package:pdpa/app/features/data_subject_right/screens/form_data_subject_right/pages/owner_verify_page.dart';
import 'package:pdpa/app/features/data_subject_right/screens/form_data_subject_right/pages/intro_page.dart';
import 'package:pdpa/app/features/data_subject_right/screens/form_data_subject_right/pages/power_verification_page.dart';
import 'package:pdpa/app/features/data_subject_right/screens/form_data_subject_right/pages/request_reason_page.dart';
import 'package:pdpa/app/features/data_subject_right/screens/form_data_subject_right/pages/reserve_the_right_page.dart';
import 'package:pdpa/app/features/data_subject_right/screens/form_data_subject_right/widgets/summit_screen.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';

import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/loading_indicator.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class FormDataSubjectRight extends StatefulWidget {
  const FormDataSubjectRight({
    super.key,
  });

  @override
  State<FormDataSubjectRight> createState() => _FormDataSubjectRightState();
}

class _FormDataSubjectRightState extends State<FormDataSubjectRight> {
  late UserModel currentUser;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    final bloc = context.read<SignInBloc>();
    if (bloc.state is SignedInUser) {
      currentUser = (bloc.state as SignedInUser).user;
    } else {
      currentUser = UserModel.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<FormDataSubJectRightBloc>(),
      // ..add(
      //   GetFormDataSubJectRightEvent(companyId: widget.companyId),
      // ),
      child: Scaffold(
        appBar: PdpaAppBar(
          leadingIcon: _buildPopButton(),
          title: Text(tr('dataSubjectRight.form')),
        ),
        body: BlocBuilder<FormDataSubjectRightCubit, FormDataSubjectRightState>(
          builder: (context, state) {
            if (state.requestFormState == RequestFormState.requesting) {
              return FormDataSubjectRightView(
                companyId: currentUser.currentCompany,
              );
            }
            if (state.requestFormState == RequestFormState.summarize) {
              return const SubmitScreen();
            }
            return const CustomContainer(
              margin: EdgeInsets.all(UiConfig.lineSpacing),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: UiConfig.defaultPaddingSpacing * 4,
                ),
                child: Center(
                  child: LoadingIndicator(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  CustomIconButton _buildPopButton() {
    return CustomIconButton(
      onPressed: () {
        context.pushReplacement(
          DataSubjectRightRoute.dataSubjectRight.path,
        );

        final RequestFormState requestFormState =
            context.read<FormDataSubjectRightCubit>().state.requestFormState;

        if (requestFormState == RequestFormState.summarize) {
          context.read<FormDataSubjectRightCubit>().resetFormDataSubjectRight();
        }
      },
      icon: Icons.chevron_left_outlined,
      iconColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }
}

class FormDataSubjectRightView extends StatefulWidget {
  const FormDataSubjectRightView({
    super.key,
    required this.companyId,
  });

  final String companyId;

  @override
  State<FormDataSubjectRightView> createState() =>
      _FormDataSubjectRightViewState();
}

class _FormDataSubjectRightViewState extends State<FormDataSubjectRightView> {
  late PageController _controller;
  late List<RequestTypeModel> requestType;
  late List<ReasonTypeModel> reasonType;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    final cubit = context.read<FormDataSubjectRightCubit>();
    _controller = PageController(
      initialPage: cubit.state.currentPage,
    );
    requestType = requestTypesPreset;
    reasonType = reasonTypesPreset;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataSubjectRight = context.select(
      (FormDataSubjectRightCubit cubit) => cubit.state.dataSubjectRight,
    );
    final currentPage = context.select(
      (FormDataSubjectRightCubit cubit) => cubit.state.currentPage,
    );
    final isAcknowledge = context.select(
      (FormDataSubjectRightCubit cubit) => cubit.state.isAcknowledge,
    );
    return Column(
      children: [
        Expanded(
          child: ContentWrapper(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _controller,
              children: <Widget>[
                IntroPage(
                  controller: _controller,
                  currentPage: currentPage,
                ),
                const OwnerVerifyPage(),
                PowerVerificationPage(
                  companyId: widget.companyId,
                ),
                const DataOwnerDetailPage(),
                IdentityVerificationPage(
                  companyId: widget.companyId,
                ),
                RequestReasonPage(
                  requestType: requestType,
                  reasonType: reasonType,
                ),
                const ReserveTheRightPage(),
                const AcknowledgePage(),
              ],
            ),
          ),
        ),
        Visibility(
          visible: currentPage != 0,
          child: ContentWrapper(
            child: Container(
              padding: const EdgeInsets.all(
                UiConfig.defaultPaddingSpacing,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.outline,
                    blurRadius: 1.0,
                    offset: const Offset(0, -2.0),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  if (currentPage != 1)
                    Align(
                      alignment: const Alignment(-0.9, -0.9),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        onPressed: () {
                          if (dataSubjectRight.isDataOwner == true &&
                              currentPage == 4) {
                            context
                                .read<FormDataSubjectRightCubit>()
                                .previousPage(1);
                            context
                                .read<FormDataSubjectRightCubit>()
                                .setDataSubjectRight(
                                    dataSubjectRight.copyWith(dataOwner: []));

                            _controller.jumpToPage(1);
                          } else {
                            context
                                .read<FormDataSubjectRightCubit>()
                                .previousPage(currentPage - 1);
                            _controller.previousPage(
                              duration: const Duration(microseconds: 1),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Text(
                          tr("app.previous"),
                        ),
                      ),
                    ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "$currentPage/7",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )),
                  Align(
                    alignment: const Alignment(0.9, -0.9),
                    child: TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        onPressed: () {
                          bool verified = true;
                          switch (currentPage) {
                            case 1:
                              final dataRequester = dataSubjectRight
                                  .dataRequester
                                  .map((requester) => requester)
                                  .toList();

                              if (dataRequester.isEmpty ||
                                  dataRequester.length != 4) {
                                verified = false;
                                BotToast.showText(
                                  text:
                                      tr('dataSubjectRight.formData.infocomplete'),
                                  contentColor: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.75),
                                  borderRadius: BorderRadius.circular(8.0),
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                                  duration: UiConfig.toastDuration,
                                );
                              }
                              break;

                            case 2:
                              final powerVerifications = dataSubjectRight
                                  .powerVerifications
                                  .map((verification) => verification)
                                  .toList();

                              if (powerVerifications.isEmpty) {
                                verified = false;
                                BotToast.showText(
                                  text: tr('dataSubjectRight.formData.doc'),
                                  contentColor: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.75),
                                  borderRadius: BorderRadius.circular(8.0),
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                                  duration: UiConfig.toastDuration,
                                );
                              }
                              for (RequesterVerificationModel verification
                                  in powerVerifications) {
                                if (verification.imageUrl.isEmpty) {
                                  verified = false;
                                  BotToast.showText(
                                    text: tr('dataSubjectRight.formData.copy'),
                                    contentColor: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.75),
                                    borderRadius: BorderRadius.circular(8.0),
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                    duration: UiConfig.toastDuration,
                                  );
                                }
                              }
                              break;
                            case 3:
                              final dataOwner = dataSubjectRight.dataOwner
                                  .map((requester) => requester)
                                  .toList();

                              if (dataOwner.isEmpty || dataOwner.length != 4) {
                                verified = false;
                                BotToast.showText(
                                  text: tr('dataSubjectRight.formData.detail'),
                                  contentColor: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.75),
                                  borderRadius: BorderRadius.circular(8.0),
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                                  duration: UiConfig.toastDuration,
                                );
                              }
                              break;
                            case 4:
                              final identityVerifications = dataSubjectRight
                                  .identityVerifications
                                  .map((verification) => verification)
                                  .toList();

                              if (identityVerifications.isEmpty) {
                                verified = false;
                                BotToast.showText(
                                  text: tr('dataSubjectRight.formData.identity'),
                                  contentColor: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.75),
                                  borderRadius: BorderRadius.circular(8.0),
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                                  duration: UiConfig.toastDuration,
                                );
                              }

                              for (RequesterVerificationModel verification
                                  in identityVerifications) {
                                if (verification.imageUrl.isEmpty) {
                                  verified = false;
                                  BotToast.showText(
                                    text: tr('dataSubjectRight.formData.copy'),
                                    contentColor: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.75),
                                    borderRadius: BorderRadius.circular(8.0),
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                    duration: UiConfig.toastDuration,
                                  );
                                }
                              }
                              break;
                            case 5:
                              final processRequests = dataSubjectRight
                                  .processRequests
                                  .map((process) => process)
                                  .toList();
                              if (processRequests.isEmpty) {
                                verified = false;
                                BotToast.showText(
                                  text: tr('dataSubjectRight.formData.purpose'),
                                  contentColor: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.75),
                                  borderRadius: BorderRadius.circular(8.0),
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                                  duration: UiConfig.toastDuration,
                                );
                              }
                              for (ProcessRequestModel process
                                  in processRequests) {
                                if (process.personalData.isEmpty) {
                                  verified = false;
                                  BotToast.showText(
                                    text: tr('dataSubjectRight.formData.personal'),
                                    contentColor: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.75),
                                    borderRadius: BorderRadius.circular(8.0),
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                    duration: UiConfig.toastDuration,
                                  );
                                }

                                if (process.requestAction.isEmpty) {
                                  verified = false;
                                  BotToast.showText(
                                    text: tr('dataSubjectRight.formData.acton'),
                                    contentColor: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.75),
                                    borderRadius: BorderRadius.circular(8.0),
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                    duration: UiConfig.toastDuration,
                                  );
                                }

                                if (process.reasonTypes.isEmpty) {
                                  verified = false;
                                  BotToast.showText(
                                    text: tr('dataSubjectRight.formData.reason'),
                                    contentColor: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.75),
                                    borderRadius: BorderRadius.circular(8.0),
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                    duration: UiConfig.toastDuration,
                                  );
                                }
                              }
                              break;
                            default:
                          }
                          if (currentPage != 7 && verified) {
                            if (dataSubjectRight.isDataOwner == true &&
                                currentPage == 1) {
                              context
                                  .read<FormDataSubjectRightCubit>()
                                  .nextPage(4);
                              context
                                  .read<FormDataSubjectRightCubit>()
                                  .setDataSubjectRight(
                                      dataSubjectRight.copyWith(
                                          dataOwner:
                                              dataSubjectRight.dataRequester));

                              _controller.jumpToPage(4);
                            } else {
                              context
                                  .read<FormDataSubjectRightCubit>()
                                  .nextPage(currentPage + 1);
                              _controller.nextPage(
                                duration: const Duration(microseconds: 1),
                                curve: Curves.easeInOut,
                              );
                            }
                          }
                          if (currentPage == 7) {
                            if (!isAcknowledge) {
                              BotToast.showText(
                                text: tr(
                                    'consentManagement.userConsent.consentFormDetails.edit.pleaseAcceptConsent'),
                                contentColor: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.75),
                                borderRadius: BorderRadius.circular(8.0),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                duration: UiConfig.toastDuration,
                              );
                            } else {
                              context
                                  .read<FormDataSubjectRightCubit>()
                                  .createDatasubjectRight(widget.companyId);

                              context
                                  .read<FormDataSubjectRightCubit>()
                                  .setSubmited();
                            }
                          }
                        },
                        child: currentPage != 7
                            ? Text(
                                tr("app.next"),
                              )
                            : Text(tr("dataSubjectRight.submitRequestForm"))),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class TEsttt extends StatefulWidget {
  const TEsttt({super.key});

  @override
  State<TEsttt> createState() => _TEstttState();
}

class _TEstttState extends State<TEsttt> {
  @override
  Widget build(BuildContext context) {
    return Text(tr('dataSubjectRight.formData.data'));
  }
}
