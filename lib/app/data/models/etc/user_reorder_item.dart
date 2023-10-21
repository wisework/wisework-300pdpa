import 'package:equatable/equatable.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class UserReorderItem extends Equatable {
  const UserReorderItem({
    required this.id,
    required this.priority,
  });

  final String id;
  final int priority;

  const UserReorderItem.empty()
      : this(
          id: '',
          priority: 0,
        );

  UserReorderItem.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          priority: map['priority'] as int,
        );

  DataMap toMap() => {id: priority};

  UserReorderItem copyWith({
    String? id,
    int? priority,
  }) {
    return UserReorderItem(
      id: id ?? this.id,
      priority: priority ?? this.priority,
    );
  }

  @override
  List<Object> get props => [id, priority];
}
