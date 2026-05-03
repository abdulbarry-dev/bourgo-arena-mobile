import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/repositories/activity_repository.dart';

/// Mock implementation of [ActivityRepository].
class MockActivityRepository implements ActivityRepository {
  @override
  Future<List<Activity>> getActivities() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const [
      Activity(
        id: '1',
        title: 'Football 5x5',
        category: 'Outdoor',
        price: 80.0,
        currency: 'TND',
        imageUrl:
            'https://images.unsplash.com/photo-1574629810360-7efbbe195018?q=80&w=2676&auto=format&fit=crop',
        icon: 'sports_soccer',
        description: 'Premium outdoor turf for 5x5 football matches.',
        features: ['Artificial Grass', 'LED Lighting', 'Showers'],
      ),
    ];
  }

  @override
  Future<Activity> getActivityById(String id) async {
    final activities = await getActivities();
    return activities.firstWhere((a) => a.id == id);
  }
}
