import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

enum ActiveStatus { active, inactive }

enum UserRoles { owner, editor, viewer }

enum UpdateType { created, updated, deleted }

final Map<TextInputType, String> textInputTypeNames = {
  TextInputType.text: 'Text',
  TextInputType.multiline: 'Multiline',
  TextInputType.number: 'Number',
  TextInputType.phone: 'Phone',
  TextInputType.datetime: 'Datetime',
  TextInputType.emailAddress: 'Email Address',
  TextInputType.url: 'URL',
  TextInputType.visiblePassword: 'Visible Password',
  TextInputType.name: 'Name',
  TextInputType.streetAddress: 'Street Address',
  TextInputType.none: 'None',
};

final Map<TextInputType, String> customInputTypeNames = {
  TextInputType.text: 'Text',
  TextInputType.multiline: 'Multiline',
  TextInputType.number: 'Number',
  TextInputType.phone: 'Phone',
  // TextInputType.datetime: 'Datetime',
  TextInputType.emailAddress: 'Email Address',
  TextInputType.url: 'URL',
  // TextInputType.visiblePassword: 'Visible Password',
  // TextInputType.name: 'Name',
  // TextInputType.streetAddress: 'Street Address',
  // TextInputType.none: 'None',
};

final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

List<String> periodUnits = ['Day', 'Month', 'Year'];

final datetimeFormatter = DateFormat('dd-MM-yyyy HH:mm:ss');

enum ConsentFormImageType { logo, header, body }
