import 'package:go_router/go_router.dart';

import 'package:pdpa/app/features/data_subject_right/screens/data_subject_right_screen.dart';
import 'package:pdpa/app/features/data_subject_right/screens/edit_data_subject_right/edit_data_subject_right_screen.dart';
import 'package:pdpa/app/features/data_subject_right/screens/form_data_subject_right/form_data_subject_right.dart';
import 'package:pdpa/app/features/data_subject_right/screens/user_data_subject_right_form_screen.dart';

class DataSubjectRightRoute {
  static final GoRoute dataSubjectRight = GoRoute(
    path: '/data-subject-rights',
    builder: (context, _) => const DataSubjectRightScreen(),
  );

  static final GoRoute createDataSubjectRight = GoRoute(
    path: '/data-subject-rights/create',
    builder: (context, state) => const FormDataSubjectRight(),
  );

  static final GoRoute editDataSubjectRight = GoRoute(
    path: '/data-subject-rights/:id1/request/:id2/edit',
    builder: (context, state) => EditDataSubjectRightScreen(
      dataSubjectRightId: state.pathParameters['id1'] ?? '',
      processRequestId: state.pathParameters['id2'] ?? '',
    ),
  );

  static final GoRoute formDataSubjectRight = GoRoute(
    path: '/data-subject-rights/:id/form',
    builder: (context, state) => EditDataSubjectRightScreen(
      dataSubjectRightId: state.pathParameters['id'] ?? '',
      processRequestId: '',
    ),
  );

  static final GoRoute userDataSubjectRightForm = GoRoute(
    path: '/companies/:id/data-subject-rights/form',
    builder: (context, state) => UserDataSubjectRightFormScreen(
      companyId: state.pathParameters['id'] ?? '',
    ),
  );

  static final List<GoRoute> routes = <GoRoute>[
    dataSubjectRight,
    createDataSubjectRight,
    editDataSubjectRight,
    formDataSubjectRight,
    userDataSubjectRightForm,
  ];
}
