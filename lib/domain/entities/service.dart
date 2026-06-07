import 'package:equatable/equatable.dart';

class Service extends Equatable {
  final int id;
  final String name;
  final String? imageUrl;
  final String? description;
  final int plansCount;
  final int coursesCount;
  final int eventsCount;
  final int activitiesCount;

  const Service({
    required this.id,
    required this.name,
    this.imageUrl,
    this.description,
    this.plansCount = 0,
    this.coursesCount = 0,
    this.eventsCount = 0,
    this.activitiesCount = 0,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    imageUrl,
    description,
    plansCount,
    coursesCount,
    eventsCount,
    activitiesCount,
  ];
}
