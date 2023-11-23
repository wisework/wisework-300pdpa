import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/search_data_subject_right/search_data_subject_right_cubit.dart';
import 'package:pdpa/app/features/data_subject_right/widgets/data_subject_right_card.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';

class SearchDataSubjectRightModal extends StatefulWidget {
  const SearchDataSubjectRightModal({
    super.key,
    required this.initialDataSubjectRights,
    required this.initialRequestTypes,
    required this.language,
  });

  final List<DataSubjectRightModel> initialDataSubjectRights;
  final List<RequestTypeModel> initialRequestTypes;
  final String language;

  @override
  State<SearchDataSubjectRightModal> createState() =>
      _SearchDataSubjectRightModalState();
}

class _SearchDataSubjectRightModalState
    extends State<SearchDataSubjectRightModal> {
  late UserModel currentUser;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  void _initialData() {
    searchController = TextEditingController();

    final bloc = context.read<SignInBloc>();
    if (bloc.state is SignedInUser) {
      currentUser = (bloc.state as SignedInUser).user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchDataSubjectRightCubit>(
      create: (context) => SearchDataSubjectRightCubit()
        ..initialDataSubjectRight(
          widget.initialDataSubjectRights,
          widget.initialRequestTypes,
        ),
      child: _buildSearchScreen(context),
    );
  }

  Widget _buildSearchScreen(BuildContext context) {
    return CustomContainer(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          Row(
            children: <Widget>[
              CustomIconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icons.chevron_left_outlined,
                iconColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.onBackground,
              ),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  height: 40.0,
                  child: Builder(builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: UiConfig.actionSpacing,
                      ),
                      child: CustomTextField(
                        controller: searchController,
                        hintText: tr('app.search'), //!
                        onChanged: (search) {
                          final cubit =
                              context.read<SearchDataSubjectRightCubit>();
                          cubit.searchDataSubjectRight(search, widget.language);
                        },
                      ),
                    );
                  }),
                ),
              ),
              Builder(
                builder: (context) {
                  return CustomIconButton(
                    backgroundColor: Theme.of(context).colorScheme.onBackground,
                    icon: Ionicons.close_outline,
                    iconColor: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      final cubit = context.read<SearchDataSubjectRightCubit>();
                      cubit.searchDataSubjectRight('', widget.language);

                      searchController.clear();
                    },
                  );
                },
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              child: BlocBuilder<SearchDataSubjectRightCubit,
                  SearchDataSubjectRightState>(
                builder: (context, state) {
                  if (state.dataSubjectRightForms.isNotEmpty) {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return _buildDataSubjectRightGroup(
                          context,
                          dataSubjectRight: state.dataSubjectRightForms[index],
                          dataSubjectRights: state.dataSubjectRightForms,
                          processRequests: state.processRequests,
                          requestTypes: state.requestTypes,
                        );
                      },
                      itemCount: state.dataSubjectRightForms.length,
                    );
                  }

                  return _buildResultNotFound(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListView _buildDataSubjectRightGroup(
    BuildContext context, {
    required DataSubjectRightModel dataSubjectRight,
    required List<DataSubjectRightModel> dataSubjectRights,
    required List<Map<String, ProcessRequestModel>> processRequests,
    required List<RequestTypeModel> requestTypes,
  }) {
    if (processRequests.isEmpty) {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final processRequest = dataSubjectRight.processRequests[index];

          return Padding(
            padding: const EdgeInsets.only(
              bottom: UiConfig.lineSpacing,
            ),
            child: DataSubjectRightCard(
              dataSubjectRight: dataSubjectRight,
              processRequest: processRequest,
              requestTypes: requestTypes,
              language: widget.language,
            ),
          );
        },
        itemCount: dataSubjectRight.processRequests.length,
      );
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        // final processRequest = dataSubjectRight.processRequests[index];

        final entry = processRequests[index].entries.first;
        final dataSubjectRight = UtilFunctions.getDataSubjectRightById(
          dataSubjectRights,
          entry.key,
        );

        return Padding(
          padding: const EdgeInsets.only(
            bottom: UiConfig.lineSpacing,
          ),
          child: DataSubjectRightCard(
            dataSubjectRight: dataSubjectRight,
            processRequest: entry.value,
            requestTypes: requestTypes,
            language: widget.language,
          ),
        );
      },
      itemCount: processRequests.length,
    );
  }

  Column _buildResultNotFound(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: UiConfig.lineSpacing),
        Image.asset(
          'assets/images/general/result-not-found.png',
        ),
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
