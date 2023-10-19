import 'package:equatable/equatable.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class UserVerification extends Equatable {
  const UserVerification({
    required this.id,
    required this.text,
    required this.imageUrl,
  });

  final String id;
  final String text;
  final String imageUrl;

  UserVerification.fromMap(DataMap map)
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

  UserVerification copyWith({
    String? id,
    String? text,
    String? imageUrl,
  }) {
    return UserVerification(
      id: id ?? this.id,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object> get props => [id, text, imageUrl];
}
