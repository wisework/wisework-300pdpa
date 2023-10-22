import 'package:equatable/equatable.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

class ReturnAndUpdate<T> extends Equatable {
  const ReturnAndUpdate({
    required this.object,
    required this.updateType,
  });

  final T object;
  final UpdateType updateType;

  ReturnAndUpdate<T> copyWith({
    T? object,
    UpdateType? updateType,
  }) {
    return ReturnAndUpdate<T>(
      object: object ?? this.object,
      updateType: updateType ?? this.updateType,
    );
  }

  @override
  List<Object?> get props => [object, updateType];
}
