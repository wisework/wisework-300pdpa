import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/data_subject_right/bloc/data_subject_right/data_subject_right_bloc.dart';
import 'package:pdpa/app/features/data_subject_right/bloc/edit_data_subject_right/edit_data_subject_right_bloc.dart';
import 'package:pdpa/app/features/data_subject_right/screens/process_data_subject_right/process_data_subject_right.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/toast.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class EditDataSubjectRightScreen extends StatefulWidget {
  const EditDataSubjectRightScreen({
    super.key,
    required this.dataSubjectRightId,
  });

  final String dataSubjectRightId;

  @override
  State<EditDataSubjectRightScreen> createState() =>
      _EditDataSubjectRightScreenState();
}

class _EditDataSubjectRightScreenState
    extends State<EditDataSubjectRightScreen> {
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
    return BlocProvider<EditDataSubjectRightBloc>(
      create: (context) => serviceLocator<EditDataSubjectRightBloc>()
        ..add(
          GetCurrentDataSubjectRightEvent(
            dataSubjectRightId: widget.dataSubjectRightId,
            companyId: currentUser.currentCompany,
          ),
        ),
      child: BlocConsumer<EditDataSubjectRightBloc, EditDataSubjectRightState>(
        listener: (context, state) {
          if (state is CreatedCurrentDataSubjectRight) {
            showToast(context, text: 'Create successfully');

            final event = UpdateDataSubjectRightsEvent(
              dataSubjectRight: state.dataSubjectRight,
              updateType: UpdateType.created,
            );
            context.read<DataSubjectRightBloc>().add(event);

            context.pop();
          }

          if (state is UpdatedCurrentDataSubjectRight) {
            showToast(context, text: 'Update successfully');
          }
        },
        builder: (context, state) {
          if (state is GotCurrentDataSubjectRight) {
            return EditDataSubjectRightView(
              initialDataSubjectRight: state.dataSubjectRight,
              requestTypes: state.requestTypes,
              reasonTypes: state.reasonTypes,
              rejectTypes: state.rejectTypes,
              emails: state.emails,
              currentUser: currentUser,
              isNewDataSubjectRight: widget.dataSubjectRightId.isEmpty,
            );
          }
          if (state is UpdatedCurrentDataSubjectRight) {
            return EditDataSubjectRightView(
              initialDataSubjectRight: state.dataSubjectRight,
              requestTypes: state.requestTypes,
              reasonTypes: state.reasonTypes,
              rejectTypes: state.rejectTypes,
              emails: state.emails,
              currentUser: currentUser,
              isNewDataSubjectRight: widget.dataSubjectRightId.isEmpty,
            );
          }
          if (state is EditDataSubjectRightError) {
            return ErrorMessageScreen(message: state.message);
          }

          return const LoadingScreen();
        },
      ),
    );
  }
}

class EditDataSubjectRightView extends StatefulWidget {
  const EditDataSubjectRightView({
    super.key,
    required this.initialDataSubjectRight,
    required this.requestTypes,
    required this.reasonTypes,
    required this.rejectTypes,
    required this.emails,
    required this.currentUser,
    required this.isNewDataSubjectRight,
  });

  final DataSubjectRightModel initialDataSubjectRight;
  final List<RequestTypeModel> requestTypes;
  final List<ReasonTypeModel> reasonTypes;
  final List<RejectTypeModel> rejectTypes;
  final List<String> emails;
  final UserModel currentUser;
  final bool isNewDataSubjectRight;

  @override
  State<EditDataSubjectRightView> createState() =>
      _EditDataSubjectRightViewState();
}

class _EditDataSubjectRightViewState extends State<EditDataSubjectRightView> {
  late DataSubjectRightModel dataSubjectRight;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    dataSubjectRight = widget.initialDataSubjectRight;
  }

  void _savePurpose() {
    if (_formKey.currentState!.validate()) {
      if (widget.isNewDataSubjectRight) {
        dataSubjectRight = dataSubjectRight.setCreate(
          widget.currentUser.email,
          DateTime.now(),
        );

        final event = CreateCurrentDataSubjectRightEvent(
          dataSubjectRight: dataSubjectRight,
          companyId: widget.currentUser.currentCompany,
        );

        context.read<EditDataSubjectRightBloc>().add(event);
      } else {
        dataSubjectRight = dataSubjectRight.setUpdate(
          widget.currentUser.email,
          DateTime.now(),
        );

        final event = UpdateCurrentDataSubjectRightEvent(
          dataSubjectRight: dataSubjectRight,
          companyId: widget.currentUser.currentCompany,
        );

        context.read<EditDataSubjectRightBloc>().add(event);
      }
    }
  }

  void _goBackAndUpdate() {
    if (!widget.isNewDataSubjectRight) {
      final event = UpdateDataSubjectRightsEvent(
        dataSubjectRight: dataSubjectRight,
        updateType: UpdateType.updated,
      );

      context.read<DataSubjectRightBloc>().add(event);
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(),
        title: Text(
          widget.isNewDataSubjectRight
              ? 'Create Data Subject Right'
              : 'Edit Data Subject Right',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          _buildSaveButton(),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: ContentWrapper(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: UiConfig.lineSpacing),
                    CustomContainer(
                      child: Text(dataSubjectRight.toString()),
                    ),
                    const SizedBox(height: UiConfig.lineSpacing),
                  ],
                ),
              ),
            ),
          ),
          ContentWrapper(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  CustomButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProcessDataSubjectRightScreen(
                            initialDataSubjectRight: dataSubjectRight,
                            emails: widget.emails,
                            currentUser: widget.currentUser,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 12.0,
                      ),
                      child: Text(
                        'ดำเนินการตรวจสอบ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  CustomIconButton _buildPopButton() {
    return CustomIconButton(
      onPressed: _goBackAndUpdate,
      icon: Icons.chevron_left_outlined,
      iconColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  Builder _buildSaveButton() {
    return Builder(builder: (context) {
      if (dataSubjectRight != widget.initialDataSubjectRight) {
        return CustomIconButton(
          onPressed: _savePurpose,
          icon: Ionicons.save_outline,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        );
      }
      return CustomIconButton(
        icon: Ionicons.save_outline,
        iconColor: Theme.of(context).colorScheme.onTertiary,
        backgroundColor: Theme.of(context).colorScheme.onBackground,
      );
    });
  }
}
