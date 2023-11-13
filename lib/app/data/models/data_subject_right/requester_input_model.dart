import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class RequesterInputModel extends Equatable {
  const RequesterInputModel({
    required this.id,
    required this.title,
    required this.text,
    required this.priority,
  });

  final String id;
  final List<LocalizedModel> title;
  final String text;
  final int priority;

  RequesterInputModel.empty()
      : this(
          id: '',
          title: [],
          text: '',
          priority: 0,
        );

  RequesterInputModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          title: List<LocalizedModel>.from(
            (map['title'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          text: map['text'] as String,
          priority: map['priority'] as int,
        );

  DataMap toMap() => {
        id: {
          'title': title,
          'text': text,
          'priority': priority,
        }
      };

  RequesterInputModel copyWith({
    String? id,
    List<LocalizedModel>? title,
    String? text,
    int? priority,
  }) {
    return RequesterInputModel(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      priority: priority ?? this.priority,
    );
  }

  @override
  List<Object> get props => [id, title, text, priority];
}
