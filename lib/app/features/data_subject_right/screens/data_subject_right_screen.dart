import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/data_subject_right/bloc/data_subject_right/data_subject_right_bloc.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/features/data_subject_right/widgets/data_subject_right_card.dart';
import 'package:pdpa/app/features/data_subject_right/widgets/search_data_subject_right_modal.dart';
import 'package:pdpa/app/shared/drawers/pdpa_drawer.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/utils/toast.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_dropdown_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/loading_indicator.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdpa/app/features/consent_management/consent_form/widgets/download_fuctions/netive_download.dart'
    if (dart.library.html) 'package:pdpa/app/features/consent_management/consent_form/widgets/download_fuctions/web_download.dart'
    // ignore: library_prefixes
    as downloadQrCode;

class DataSubjectRightScreen extends StatefulWidget {
  const DataSubjectRightScreen({super.key});

  @override
  State<DataSubjectRightScreen> createState() => _DataSubjectRightScreenState();
}

class _DataSubjectRightScreenState extends State<DataSubjectRightScreen> {
  late String language;
  late String companyId;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    final bloc = context.read<SignInBloc>();

    if (bloc.state is SignedInUser) {
      companyId = (bloc.state as SignedInUser).user.currentCompany;
      language = (bloc.state as SignedInUser).user.defaultLanguage;
    }

    final event = GetDataSubjectRightsEvent(companyId: companyId);
    context.read<DataSubjectRightBloc>().add(event);
  }

  @override
  Widget build(BuildContext context) {
    return DataSubjectRightView(
      language: language,
      companyId: companyId,
    );
  }
}

class DataSubjectRightView extends StatefulWidget {
  const DataSubjectRightView({
    super.key,
    required this.language,
    required this.companyId,
  });

  final String language;
  final String companyId;

  @override
  State<DataSubjectRightView> createState() => _DataSubjectRightViewState();
}

class _DataSubjectRightViewState extends State<DataSubjectRightView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _openSeachConsentFormModal() {
    final bloc = context.read<DataSubjectRightBloc>();

    List<DataSubjectRightModel> dataSubjectRights = [];
    List<RequestTypeModel> requestTypes = [];
    if (bloc.state is GotDataSubjectRights) {
      dataSubjectRights =
          (bloc.state as GotDataSubjectRights).dataSubjectRights;
      requestTypes = (bloc.state as GotDataSubjectRights).requestTypes;
    }

    showBarModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SearchDataSubjectRightModal(
        initialDataSubjectRights: dataSubjectRights,
        initialRequestTypes: requestTypes,
        language: widget.language,
      ),
    );
  }

  final qrCodeKey = GlobalKey();

  ProcessRequestFilter filterSelected = ProcessRequestFilter.all;

  final Map<ProcessRequestFilter, String> filterTexts = {
    ProcessRequestFilter.all: tr('dataSubjectRight.processRequestFilter.all'),
    ProcessRequestFilter.notProcessed: tr('dataSubjectRight.processRequestFilter.notStarted'),
    ProcessRequestFilter.inProgress: tr('dataSubjectRight.processRequestFilter.process'),
    ProcessRequestFilter.refused: tr('dataSubjectRight.processRequestFilter.refuse'),
    ProcessRequestFilter.completed: tr('dataSubjectRight.processRequestFilter.finish'),
  };

  void _setFilter(ProcessRequestFilter? value) {
    if (value != null) {
      setState(() {
        filterSelected = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PdpaAppBar(
        leadingIcon: CustomIconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icons.menu_outlined,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          tr('app.features.datasubjectright'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          CustomIconButton(
            onPressed: () {
              final path = DataSubjectRightRoute.userDataSubjectRightForm.path;
              final dsrFormUrl =
                  '${AppConfig.baseUrl}/#${path.replaceFirst(':id', widget.companyId)}';

              showMaterialModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => SingleChildScrollView(
                  child: Center(
                    child: ContentWrapper(
                      child: CustomContainer(
                        margin: EdgeInsets.zero,
                        child: _buildShareDataSubjectRight(
                          context,
                          url: dsrFormUrl,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            icon: Ionicons.link_outline,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
          CustomIconButton(
            onPressed: _openSeachConsentFormModal,
            icon: Ionicons.search_outline,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
        ],
      ),
      body: ContentWrapper(
        child: BlocBuilder<DataSubjectRightBloc, DataSubjectRightState>(
          builder: (context, state) {
            if (state is GotDataSubjectRights) {
              return _buildDataSubjectRightView(
                context,
                dataSubjectRights: state.dataSubjectRights,
                requestTypes: state.requestTypes,
              );
            }
            if (state is DataSubjectRightError) {
              return CustomContainer(
                margin: const EdgeInsets.all(UiConfig.lineSpacing),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: UiConfig.defaultPaddingSpacing * 4,
                  ),
                  child: Center(
                    child: Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              );
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(DataSubjectRightRoute.createDataSubjectRight.path
              .replaceFirst(':id', widget.companyId));
        },
        child: const Icon(Icons.add),
      ),
      drawer: PdpaDrawer(
        onClosed: () {
          _scaffoldKey.currentState?.closeDrawer();
        },
      ),
    );
  }

  Column _buildDataSubjectRightView(
    BuildContext context, {
    required List<DataSubjectRightModel> dataSubjectRights,
    required List<RequestTypeModel> requestTypes,
  }) {
    return Column(
      children: <Widget>[
        const SizedBox(height: UiConfig.lineSpacing),
        if (dataSubjectRights.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              left: UiConfig.lineGap * 2,
              right: UiConfig.lineGap * 2,
              bottom: UiConfig.lineSpacing,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    tr('consentManagement.consentForm.consentList'),
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  width: 190.0,
                  child: CustomDropdownButton<ProcessRequestFilter>(
                    value: filterSelected,
                    items: ProcessRequestFilter.values.map(
                      (value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(
                            filterTexts[value] ?? '',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      },
                    ).toList(),
                    onSelected: _setFilter,
                    height: 38.0,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: UiConfig.lineGap * 2,
                right: UiConfig.lineGap * 2,
                bottom: UiConfig.lineSpacing,
              ),
              child: _buildDataSubjectRightListView(
                context,
                dataSubjectRights: dataSubjectRights,
                requestTypes: requestTypes,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataSubjectRightListView(
    BuildContext context, {
    required List<DataSubjectRightModel> dataSubjectRights,
    required List<RequestTypeModel> requestTypes,
  }) {
    if (dataSubjectRights.isEmpty) {
      return _buildResultNotFound(context);
    }

    final processRequestFiltered = UtilFunctions.filterAllProcessRequest(
      dataSubjectRights,
      filterSelected,
    );

    if (processRequestFiltered.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: UiConfig.lineSpacing * 4,
        ),
        child: Text(
          tr('dataSubjectRight.noMatching'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final entry = processRequestFiltered[index].entries.first;
        final dataSubjectRight = UtilFunctions.getDataSubjectRightById(
          dataSubjectRights,
          entry.key,
        );

        return Padding(
          padding: const EdgeInsets.only(),
          child: DataSubjectRightCard(
            dataSubjectRight: dataSubjectRight,
            processRequest: entry.value,
            requestTypes: requestTypes,
            language: widget.language,
          ),
        );
      },
      itemCount: processRequestFiltered.length,
      separatorBuilder: (context, index) => const SizedBox(
        height: UiConfig.lineSpacing,
      ),
    );
  }

  Column _buildShareDataSubjectRight(
    BuildContext context, {
    required String url,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.topRight,
          child: MaterialInkWell(
            borderRadius: BorderRadius.circular(13.0),
            backgroundColor:
                Theme.of(context).colorScheme.outlineVariant.withOpacity(0.4),
            onTap: () async {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.only(
                left: 2.0,
                top: 1.0,
                right: 2.0,
                bottom: 3.0,
              ),
              child: Icon(
                Ionicons.close_outline,
                size: 16.0,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(UiConfig.textLineSpacing),
          child: Text(
            tr("consentManagement.consentForm.consentFormDetails.form.shareLinkForm"),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(UiConfig.textLineSpacing),
          child: Text(
            tr("consentManagement.consentForm.consentFormDetails.form.descriptionShare"),
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            _buildQrDataSubjectRight(context, url: url),
            const SizedBox(height: UiConfig.lineSpacing),
            _buildDataSubjectRightLink(context, url: url),
            const SizedBox(height: UiConfig.lineSpacing),
          ],
        ),
      ],
    );
  }

  Row _buildQrDataSubjectRight(
    BuildContext context, {
    required String url,
  }) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                width: 1.0,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RepaintBoundary(
                        key: qrCodeKey,
                        child: QrImageView(
                          data: url,
                          size: 160,
                          backgroundColor: Colors.white,
                          version: QrVersions.auto,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: CustomIconButton(
            onPressed: () async {
              // downloadQrCode.downloadQrcode(qrKey);
              await downloadQrCode.downloadQrCode(qrCodeKey).then((value) {
                if (value) {
                  showToast(
                    context,
                    text: tr(
                      'consentManagement.consentForm.urltab.qrCodeHasBeenDownloaded',
                    ),
                  );
                } else {
                  showToast(
                    context,
                    text: tr(
                      'consentManagement.consentForm.urltab.failedToDownloadQrCode',
                    ),
                  );
                }
              });
            },
            icon: Icons.file_download_outlined,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
    );
  }

  Row _buildDataSubjectRightLink(
    BuildContext context, {
    required String url,
  }) {
    return Row(
      children: <Widget>[
        Expanded(
          child: CustomTextField(
            controller: TextEditingController(
              text: url,
            ),
            readOnly: true,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: CustomIconButton(
            onPressed: () {
              Clipboard.setData(
                ClipboardData(text: url),
              );

              showToast(
                context,
                text: tr(
                  'consentManagement.consentForm.urltab.urlCopied',
                ),
              );
            },
            icon: Ionicons.copy_outline,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
    );
  }

  Column _buildResultNotFound(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: UiConfig.lineSpacing),
        Image.asset(
          'assets/images/general/result-not-found-dsr.png',
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        Text(
          tr('app.features.resultNotFound'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UiConfig.defaultPaddingSpacing * 2,
          ),
          child: Text(
            tr('app.features.description'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
