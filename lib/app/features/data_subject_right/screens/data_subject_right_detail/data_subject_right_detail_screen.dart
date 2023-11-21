import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';

class DataSubjectRightDetailScreen extends StatefulWidget {
  const DataSubjectRightDetailScreen({
    super.key,
    required this.dataSubjectRightId,
  });

  final String dataSubjectRightId;

  @override
  State<DataSubjectRightDetailScreen> createState() =>
      _DataSubjectRightDetailScreenState();
}

class _DataSubjectRightDetailScreenState
    extends State<DataSubjectRightDetailScreen> {
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
    return const DataSubjectRightView();
  }
}

class DataSubjectRightView extends StatefulWidget {
  const DataSubjectRightView({super.key});

  @override
  State<DataSubjectRightView> createState() => _DataSubjectRightViewState();
}

class _DataSubjectRightViewState extends State<DataSubjectRightView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
