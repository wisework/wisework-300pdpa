import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/etc/updated_return.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_radio_button.dart';

class ChooseRequestModal extends StatefulWidget {
  const ChooseRequestModal({
    super.key,
    required this.initialRequests,
    required this.requests,
    required this.onChanged,
    required this.onUpdated,
    required this.language,
  });

  final List<RequestTypeModel> initialRequests;
  final List<RequestTypeModel> requests;
  final Function(List<RequestTypeModel> requests) onChanged;
  final Function(UpdatedReturn<RequestTypeModel> request) onUpdated;
  final String language;

  @override
  State<ChooseRequestModal> createState() => _ChooseRequestModalState();
}

class _ChooseRequestModalState extends State<ChooseRequestModal> {
  late List<RequestTypeModel> requests;
  late List<RequestTypeModel> selectRequests;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    requests = widget.requests
        .where((request) => request.status != ActiveStatus.inactive)
        .map((request) => request)
        .toList();
    selectRequests = widget.initialRequests
        .where((request) => request.status != ActiveStatus.inactive)
        .map((request) => request)
        .toList();
  }

  void _selectRequest(RequestTypeModel request) {
    final selectIds = selectRequests.map((selected) => selected.id).toList();

    setState(() {
      if (selectIds.contains(request.id)) {
        selectRequests = selectRequests
            .where((selected) => selected.id != request.id)
            .toList();
      } else {
        selectRequests = selectRequests.map((selected) => selected).toList()
          ..add(request);
      }
    });

    widget.onChanged(selectRequests);
  }

  @override
  Widget build(BuildContext context) {
    String selectedOption =
        selectRequests.map((e) => e.id).toString(); // Default selected option

    void handleRadioValueChanged(String value) {
      setState(() {
        selectedOption = value;
      });
    }

    return Material(
      child: CupertinoPageScaffold(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(top: UiConfig.lineSpacing),
            child: _buildModalContent(context),
          ),
        ),
      ),
    );
  }

  Column _buildModalContent(BuildContext context) {
    return Column(
      children: <Widget>[
        Material(
          elevation: 1.0,
          color: Theme.of(context).colorScheme.onBackground,
          child: Padding(
            padding: const EdgeInsets.only(
              left: UiConfig.defaultPaddingSpacing,
              right: UiConfig.defaultPaddingSpacing,
              bottom: UiConfig.lineGap,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    tr('masterData.cm.request.list'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200.0),
                  child: _buildAddButton(context),
                ),
                const SizedBox(width: UiConfig.defaultPaddingSpacing),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 95.0),
                  child: CustomButton(
                    height: 40.0,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      tr('app.done'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ), //!
        const SizedBox(height: UiConfig.lineSpacing),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: UiConfig.defaultPaddingSpacing,
            ),
            itemCount: requests.length,
            itemBuilder: (_, index) {
              if (requests.isEmpty) {
                return Text(
                  tr('masterData.cm.requestCategory.noData'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ); //!
              }
              return Column(
                children: <Widget>[
                  _buildCheckBoxListTile(
                    context,
                    request: requests[index],
                    language: widget.language,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    child: Divider(
                      color: Theme.of(context)
                          .colorScheme
                          .outlineVariant
                          .withOpacity(0.5),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Row _buildCheckBoxListTile(
    BuildContext context, {
    required RequestTypeModel request,
    required String language,
  }) {
    final description = request.description.firstWhere(
              (item) => item.language == language,
              orElse: () => const LocalizedModel.empty(),
            ) !=
            ''
        ? request.description.last.text
        : '';

    final selectIds = selectRequests.map((category) => category.id).toList();

    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 4.0,
            right: UiConfig.actionSpacing,
          ),
          child: CustomRadioButton(
            value: request.id,
            selected: selectIds.contains(request.id),
            onChanged: (_) {
              _selectRequest(request);
            },
          ),
        ),
        Expanded(
          child: Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  CustomIconButton _buildAddButton(BuildContext context) {
    return CustomIconButton(
      onPressed: () async {
        await context
            .push(MasterDataRoute.createRequestType.path)
            .then((value) {
          if (value != null) {
            final updated = value as UpdatedReturn<RequestTypeModel>;

            requests = requests..add(updated.object);
            _selectRequest(updated.object);

            widget.onUpdated(updated);
          }
        });
      },
      icon: Ionicons.add,
      iconColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }
}
