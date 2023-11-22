import 'package:equatable/equatable.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class RequesterVerificationModel extends Equatable {
  const RequesterVerificationModel({
    required this.id,
    required this.text,
    required this.imageUrl,
  });

  final String id;
  final String text;
  final String imageUrl;

  const RequesterVerificationModel.empty()
      : this(
          id: '',
          text: '',
          imageUrl: '',
        );

  RequesterVerificationModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          text: map['text'] as String,
          imageUrl: map['imageUrl'] as String,
        );

  DataMap toMap() => {
        id: {
          'text': text,
          'imageUrl': imageUrl,
        }
      };

  RequesterVerificationModel copyWith({
    String? id,
    String? text,
    String? imageUrl,
  }) {
    return RequesterVerificationModel(
      id: id ?? this.id,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object> get props => [id, text, imageUrl];
}
