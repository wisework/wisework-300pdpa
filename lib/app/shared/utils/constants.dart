import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

final List<String> alphabets = [
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u',
  'v',
  'w',
  'x',
  'y',
  'z',
];

final List<String> numbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

final List<String> languages = ['en-US', 'th-TH'];

enum SortType { asc, desc }

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

// final Map<TextInputType, String> customInputTypeNames = {
//   TextInputType.text: tr('app.text'),
//   TextInputType.multiline: tr('app.multiline'),
//   TextInputType.number: tr('app.number'),
//   TextInputType.phone: tr('app.phone'),
//   TextInputType.emailAddress: tr('app.emailAddress'),
//   TextInputType.url: tr('app.url'),
// };

final emailRegex = RegExp(r'^[\w-]+(.[\w-]+)*@[\w-]+(.[\w-]+)+$');

List<String> periodUnits = ['Day', 'Month', 'Year'];

final dateFormatter = DateFormat('dd-MM-yyyy');
final timeFormatter = DateFormat('HH:mm:ss');
final datetimeFormatter = DateFormat('dd-MM-yyyy HH:mm:ss');

enum ConsentFormImageType { logo, header, body }

enum RequestResultStatus { pass, fail, none }

enum ProcessRequestStatus { notProcessed, inProgress, refused, completed }

const fileImageType = <String>['jpg', 'jpeg', 'png'];
