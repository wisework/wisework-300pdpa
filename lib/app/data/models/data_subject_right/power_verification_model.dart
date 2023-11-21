import 'package:equatable/equatable.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class PowerVerificationModel extends Equatable {
  const PowerVerificationModel({
    required this.id,
    required this.title,
    required this.additionalReq,
  });

  final String id;
  final String title;
  final bool additionalReq;

  PowerVerificationModel copyWith({
    String? id,
    String? title,
    bool? additionalReq,
  }) {
    return PowerVerificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      additionalReq: additionalReq ?? this.additionalReq,
    );
  }

  const PowerVerificationModel.empty()
      : this(
          id: '',
          title: '',
          additionalReq: false,
        );

  PowerVerificationModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          title: map['title'] as String,
          additionalReq: map['additionalReq'] as bool,
        );

  DataMap toMap() => {
        id: {
          'id': id,
          'title': title,
          'additionalReq': additionalReq,
        }
      };

  @override
  List<Object> get props => [
        id,
        title,
        additionalReq,
      ];
}
