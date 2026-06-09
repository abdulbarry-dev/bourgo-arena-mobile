import 'package:bourgo_arena_mobile/domain/entities/activity.dart';
import 'package:bourgo_arena_mobile/domain/entities/child_profile.dart';
import 'package:bourgo_arena_mobile/domain/entities/course.dart';
import 'package:bourgo_arena_mobile/domain/entities/notification.dart';
import 'package:bourgo_arena_mobile/domain/entities/reservation.dart';
import 'package:bourgo_arena_mobile/domain/entities/search_result.dart';
import 'package:bourgo_arena_mobile/domain/entities/subscription.dart';
import 'package:bourgo_arena_mobile/domain/entities/time_slot.dart';
import 'package:bourgo_arena_mobile/domain/entities/user.dart';
import 'package:checks/checks.dart';
import 'package:test/test.dart';

void main() {
  group('Domain Entities', () {
    group('Activity', () {
      const activity1 = Activity(
        id: '1',
        title: 'Tennis',
        name: 'Tennis',
        category: 'Indoor',
        basePrice: 20.0,
        currency: 'EUR',
        imageUrl: 'url',
        images: ['url'],
        icon: 'tennis_icon',
        description: 'Tennis description',
        features: ['Court', 'Rackets'],
        rating: 4.5,
        reviewCount: 10,
      );

      const activity2 = Activity(
        id: '1',
        title: 'Tennis',
        name: 'Tennis',
        category: 'Indoor',
        basePrice: 20.0,
        currency: 'EUR',
        imageUrl: 'url',
        images: ['url'],
        icon: 'tennis_icon',
        description: 'Tennis description',
        features: ['Court', 'Rackets'],
        rating: 4.5,
        reviewCount: 10,
      );

      const activityDifferent = Activity(
        id: '2',
        title: 'Football',
        name: 'Football',
        category: 'Outdoor',
        basePrice: 15.0,
        currency: 'EUR',
        imageUrl: 'url',
        images: ['url'],
        icon: 'football_icon',
        description: 'Football description',
        features: ['Field'],
        rating: 4.0,
        reviewCount: 5,
      );

      test('equality and hashCode should work correctly', () {
        check(activity1).equals(activity2);
        check(activity1.hashCode).equals(activity2.hashCode);

        check(activity1).not((p0) => p0.equals(activityDifferent));
      });

      test('deep equality for features list should work', () {
        final activityWithSameFeatures = Activity(
          id: '1',
          title: 'Tennis',
          name: 'Tennis',
          category: 'Indoor',
          basePrice: 20.0,
          currency: 'EUR',
          imageUrl: 'url',
          images: ['url'],
          icon: 'tennis_icon',
          description: 'Tennis description',
          features: List.from(['Court', 'Rackets']),
          rating: 4.5,
          reviewCount: 10,
        );

        check(activity1).equals(activityWithSameFeatures);
      });
    });

    group('ChildProfile', () {
      final birthDate = DateTime(2015, 5, 20);
      final child1 = ChildProfile(
        id: 'c1',
        firstName: 'John',
        lastName: 'Doe',
        birthDate: birthDate,
        gender: 'Male',
      );

      final child2 = ChildProfile(
        id: 'c1',
        firstName: 'John',
        lastName: 'Doe',
        birthDate: birthDate,
        gender: 'Male',
      );

      test('equality and hashCode should work correctly', () {
        check(child1).equals(child2);
        check(child1.hashCode).equals(child2.hashCode);
      });

      test('name getter should return full name', () {
        check(child1.name).equals('John Doe');
      });

      test('copyWith should create a new instance with updated fields', () {
        final updatedChild = child1.copyWith(firstName: 'Jane');

        check(updatedChild.firstName).equals('Jane');
        check(updatedChild.lastName).equals(child1.lastName);
        check(updatedChild.id).equals(child1.id);
      });
    });

    group('Course', () {
      const course1 = Course(
        id: 'course1',
        name: 'Yoga',
        description: 'Morning yoga class',
        images: ['https://img.com/yoga.jpg'],
        imageUrl: 'https://img.com/yoga.jpg',
        status: 'active',
      );

      const course2 = Course(
        id: 'course2',
        name: 'Pilates',
        images: [],
        status: 'inactive',
      );

      test('equality should work correctly', () {
        check(course1).equals(course1);
        check(course1).not((p) => p.equals(course2));
      });
    });

    group('CourseSession', () {
      final session1 = CourseSession(
        id: 's1',
        title: 'Morning Yoga',
        startTime: '08:00',
        endTime: '09:00',
        dayOfWeek: 1,
        capacity: 20,
        enrolled: 15,
        imageUrl: 'https://img.com/yoga.jpg',
      );

      final sessionFull = CourseSession(
        id: 's2',
        title: 'Pilates',
        startTime: '10:00',
        endTime: '11:00',
        dayOfWeek: 2,
        capacity: 10,
        enrolled: 10,
      );

      test('isFull should return correct value', () {
        check(session1.isFull).isFalse();
        check(sessionFull.isFull).isTrue();
      });

      test('remainingSpots should return correct value', () {
        check(session1.remainingSpots).equals(5);
        check(sessionFull.remainingSpots).equals(0);
      });

      test('equality should work correctly', () {
        check(session1).equals(session1);
        check(session1).not((p) => p.equals(sessionFull));
      });
    });

    group('Notification', () {
      final now = DateTime.now();
      final notification1 = Notification(
        id: 1,
        title: 'Title',
        message: 'Message',
        timestamp: now,
        type: 'booking',
        isRead: false,
      );

      test('copyWith should update correctly', () {
        final readNotification = notification1.copyWith(isRead: true);
        check(readNotification.isRead).isTrue();
        check(readNotification.id).equals(notification1.id);
      });
    });

    group('Reservation', () {
      const reservation1 = Reservation(
        id: 'r1',
        activityId: 'a1',
        activityTitle: 'Tennis',
        date: '2023-10-27',
        time: '18:00',
        duration: '1h',
        price: 20.0,
        status: 'confirmed',
        paymentStatus: 'paid',
        qrCode: 'qr_data',
      );

      test('equality should work correctly', () {
        const reservation2 = Reservation(
          id: 'r1',
          activityId: 'a1',
          activityTitle: 'Tennis',
          date: '2023-10-27',
          time: '18:00',
          duration: '1h',
          price: 20.0,
          status: 'confirmed',
          paymentStatus: 'paid',
          qrCode: 'qr_data',
        );
        check(reservation1).equals(reservation2);
      });
    });

    group('SearchResult', () {
      const result1 = SearchResult(
        title: 'Tennis',
        subtitle: 'Indoor activity',
        type: SearchResultType.activity,
        iconKey: 'tennis',
        route: '/activity/1',
      );

      test('equality should work correctly', () {
        const result2 = SearchResult(
          title: 'Tennis',
          subtitle: 'Indoor activity',
          type: SearchResultType.activity,
          iconKey: 'tennis',
          route: '/activity/1',
        );
        check(result1).equals(result2);
      });
    });

    group('Subscription', () {
      const sub1 = Subscription(id: 's1', status: 'active');

      test('equality should work', () {
        const subSame = Subscription(id: 's1', status: 'active');
        check(sub1).equals(subSame);
      });
    });

    group('TimeSlot', () {
      const slot1 = TimeSlot(time: '18:00', available: true);
      const slot2 = TimeSlot(time: '18:00', available: true);

      test('equality should work', () {
        check(slot1).equals(slot2);
      });
    });

    group('User', () {
      final user1 = User(
        id: 'u1',
        firstName: 'Alice',
        lastName: 'Smith',
        email: 'alice@example.com',
        phone: '123456',
        avatarUrl: 'url',
        loyaltyPoints: 100,
        subscriptionLevel: 'Gold',
        subscriptionExpiry: DateTime.utc(2024, 1, 1),
        children: [
          ChildProfile(
            id: 'c1',
            firstName: 'Bob',
            lastName: 'Smith',
            birthDate: DateTime(2018, 1, 1),
          ),
        ],
      );

      test('name getter should return full name', () {
        check(user1.name).equals('Alice Smith');
      });

      test('equality should work correctly including children list', () {
        final user2 = User(
          id: 'u1',
          firstName: 'Alice',
          lastName: 'Smith',
          email: 'alice@example.com',
          phone: '123456',
          avatarUrl: 'url',
          loyaltyPoints: 100,
          subscriptionLevel: 'Gold',
          subscriptionExpiry: DateTime.utc(2024, 1, 1),

          children: [
            ChildProfile(
              id: 'c1',
              firstName: 'Bob',
              lastName: 'Smith',
              birthDate: DateTime(2018, 1, 1),
            ),
          ],
        );
        check(user1).equals(user2);
      });

      test('copyWith should work', () {
        final updatedUser = user1.copyWith(firstName: 'Alicia');
        check(updatedUser.firstName).equals('Alicia');
        check(updatedUser.id).equals(user1.id);
      });
    });
  });
}
