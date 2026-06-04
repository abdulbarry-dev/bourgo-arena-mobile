import 'package:equatable/equatable.dart';

class Service extends Equatable {
  final int id;
  final String name;
  final String? imageUrl;
  final String? description;

  const Service({
    required this.id,
    required this.name,
    this.imageUrl,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, imageUrl, description];
}
