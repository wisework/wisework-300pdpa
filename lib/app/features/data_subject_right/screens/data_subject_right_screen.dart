import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/requester_input_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/requester_verification_model.dart';
import 'package:pdpa/app/data/models/etc/user_input_text.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/data/repositories/data_subject_right_repository.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/data_subject_right/bloc/data_subject_right/data_subject_right_bloc.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/features/data_subject_right/widgets/data_subject_right_card.dart';
import 'package:pdpa/app/features/data_subject_right/widgets/search_data_subject_right_modal.dart';
import 'package:pdpa/app/services/apis/data_subject_right_api.dart';
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
import 'package:pdpa/app/shared/widgets/screens/example_screen.dart';
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
    ProcessRequestFilter.all: 'ทั้งหมด',
    ProcessRequestFilter.notProcessed: 'ยังไม่เริ่ม',
    ProcessRequestFilter.inProgress: 'ระหว่างดำเนินการ',
    ProcessRequestFilter.refused: 'ปฏิเสธคำร้อง',
    ProcessRequestFilter.completed: 'เสร็จสิ้น',
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
              showModalBottomSheet(
                context: context,
                builder: (context) => Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SingleChildScrollView(
                    child: CustomContainer(
                      child: _buildShareConsentForm(context),
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
                    tr('consentManagement.consentForm.consentList'), //!
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
      return ExampleScreen(
        headderText: tr(
          'consentManagement.consentForm.consentForms',
        ),
        buttonText: tr(
          'consentManagement.consentForm.createForm.create',
        ),
        descriptionText: tr(
          'consentManagement.consentForm.explain',
        ),
        onPress: () {
          // context.push(
          //   DataSubjectRightRoute.createDataSubjectRight.path,
          // );

          final now = DateTime.now();
          final dsr = DataSubjectRightModel(
            id: '',
            dataRequester: const [
              RequesterInputModel(
                id: 'DSR-DATA-REQ-001',
                title: [
                  LocalizedModel(
                    language: 'en-US',
                    text: 'Name',
                  ),
                  LocalizedModel(
                    language: 'th-TH',
                    text: 'ชื่อ - นามสกุล',
                  ),
                ],
                text: 'เหมียว เหมียว',
                priority: 1,
              ),
              RequesterInputModel(
                id: 'DSR-DATA-REQ-002',
                title: [
                  LocalizedModel(language: 'en-US', text: 'Address'),
                  LocalizedModel(language: 'th-TH', text: 'ที่อยู่'),
                ],
                text: 'โคราชซิตี้',
                priority: 2,
              ),
              RequesterInputModel(
                id: 'DSR-DATA-REQ-003',
                title: [
                  LocalizedModel(language: 'en-US', text: 'Email'),
                  LocalizedModel(language: 'th-TH', text: 'อีเมล'),
                ],
                text: 'Sage.Online2000@gmail.com',
                priority: 3,
              ),
              RequesterInputModel(
                id: 'DSR-DATA-REQ-004',
                title: [
                  LocalizedModel(
                    language: 'en-US',
                    text: 'Phone Number',
                  ),
                  LocalizedModel(
                    language: 'th-TH',
                    text: 'หมายเลขโทรศัพท์',
                  ),
                ],
                text: '0612345678',
                priority: 4,
              ),
            ],
            dataOwner: const [
              RequesterInputModel(
                id: 'DSR-DATA-OWN-001',
                title: [
                  LocalizedModel(
                    language: 'en-US',
                    text: 'Name',
                  ),
                  LocalizedModel(
                    language: 'th-TH',
                    text: 'ชื่อ - นามสกุล',
                  ),
                ],
                text: 'กานต์ ขุนทิพย์',
                priority: 1,
              ),
              RequesterInputModel(
                id: 'DSR-DATA-OWN-002',
                title: [
                  LocalizedModel(language: 'en-US', text: 'Address'),
                  LocalizedModel(language: 'th-TH', text: 'ที่อยู่'),
                ],
                text: 'ปากช่องซิตี้',
                priority: 2,
              ),
              RequesterInputModel(
                id: 'DSR-DATA-OWN-003',
                title: [
                  LocalizedModel(language: 'en-US', text: 'Email'),
                  LocalizedModel(language: 'th-TH', text: 'อีเมล'),
                ],
                text: 'khunthip.city@gmail.com',
                priority: 3,
              ),
              RequesterInputModel(
                id: 'DSR-DATA-OWN-004',
                title: [
                  LocalizedModel(
                    language: 'en-US',
                    text: 'Phone Number',
                  ),
                  LocalizedModel(
                    language: 'th-TH',
                    text: 'หมายเลขโทรศัพท์',
                  ),
                ],
                text: '0981234567',
                priority: 4,
              ),
            ],
            isDataOwner: false,
            powerVerifications: const [
              RequesterVerificationModel(
                id: 'DSR-PV-001',
                text: 'Profile',
                imageUrl: 'karnza.jpg',
              ),
            ],
            identityVerifications: const [
              RequesterVerificationModel(
                id: 'DSR-IV-001',
                text: 'Proof',
                imageUrl: 'karnza.jpg',
              ),
            ],
            processRequests: const [
              ProcessRequestModel(
                id: 'DSR-PR-001',
                personalData: 'รูปโปรไฟล์',
                foundSource: 'www.mock-web.co.th/info',
                requestType: 'DSR-REQ-002',
                requestAction: 'DSR-REA-001',
                reasonTypes: [
                  UserInputText(id: 'DSR-RES-002', text: ''),
                  UserInputText(id: 'DSR-RES-003', text: ''),
                  UserInputText(
                    id: 'DSR-RES-004',
                    text: 'เหตุผลส่วนตัวเด้อสู',
                  ),
                ],
                considerRequestStatus: RequestResultStatus.none,
                rejectTypes: [],
                rejectConsiderReason: '',
                notifyEmail: [],
                proofOfActionFile: '',
                proofOfActionText: '',
              ),
              ProcessRequestModel(
                id: 'DSR-PR-002',
                personalData: 'ข้อมูลส่วนตัว',
                foundSource: 'www.mock-web.co.th/news',
                requestType: 'DSR-REQ-003',
                requestAction: 'DSR-REA-001',
                reasonTypes: [
                  UserInputText(id: 'DSR-RES-002', text: ''),
                  UserInputText(id: 'DSR-RES-004', text: 'เหตุผลส่วนตัวเด้อสู'),
                ],
                considerRequestStatus: RequestResultStatus.none,
                rejectTypes: [],
                rejectConsiderReason: '',
                notifyEmail: [],
                proofOfActionFile: '',
                proofOfActionText: '',
              ),
            ],
            requestExpirationDate: now.add(const Duration(days: 30)),
            verifyFormStatus: RequestResultStatus.none,
            rejectVerifyReason: '',
            lastSeenBy: '',
            createdBy: 'Sage.Online2000@gmail.com',
            createdDate: now,
            updatedBy: 'Sage.Online2000@gmail.com',
            updatedDate: now,
          );
          final repository = DataSubjectRightRepository(
            DataSubjectRightApi(FirebaseFirestore.instance),
          );
          repository
              .createDataSubjectRight(dsr, 'Y7gRT2kc3bC1i80iKVaF')
              .then((value) => showToast(context, text: 'success'));
        },
      );
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
          'ไม่พบคำร้องที่ตรงกัน',
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

  Column _buildShareConsentForm(BuildContext context) {
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
            _buildQrDataSubjectRight(context),
            const SizedBox(height: UiConfig.lineSpacing),
            _buildDatSubjectRightLink(context),
            const SizedBox(height: UiConfig.lineSpacing),
          ],
        ),
      ],
    );
  }

  Row _buildQrDataSubjectRight(BuildContext context) {
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
                          data: 'www.google.com',
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

  Row _buildDatSubjectRightLink(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: CustomTextField(
            controller: TextEditingController(
              text: 'www.google.com',
            ),
            readOnly: true,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: CustomIconButton(
            onPressed: () {
              Clipboard.setData(
                const ClipboardData(text: 'www.google.com'),
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
}
