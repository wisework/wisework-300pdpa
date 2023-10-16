import 'package:easy_localization/easy_localization.dart';

enum ActiveStatus { active, inactive }

enum UserRoles { owner, editor, viewer }

enum UpdateType { created, updated, deleted }

List<String> periodUnits = ['Day', 'Month', 'Year'];

final datetimeFormatter = DateFormat('dd-MM-yyyy HH:mm:ss');

enum ConsentFormImageType { logo, header, body }
