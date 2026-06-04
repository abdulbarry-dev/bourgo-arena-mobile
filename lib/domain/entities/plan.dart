import 'package:equatable/equatable.dart';

class Plan extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String billingCycle;
  final String? serviceImageUrl;

  const Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.billingCycle,
    this.serviceImageUrl,
  });

  @override
  List<Object?> get props => [id, name, description, price, billingCycle, serviceImageUrl];
}
