import 'package:equatable/equatable.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

class UpdatedReturn<T> extends Equatable {
  const UpdatedReturn({
    required this.object,
    required this.type,
  });

  final T object;
  final UpdateType type;

  UpdatedReturn<T> copyWith({
    T? object,
    UpdateType? type,
  }) {
    return UpdatedReturn<T>(
      object: object ?? this.object,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [object, type];
}
