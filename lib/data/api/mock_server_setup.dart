import 'package:flutter_api_mock_server/flutter_api_mock_server.dart';

/// Configures the [MockServer] with initial data.
class MockServerSetup {
  static void configure(MockServer server) {
    // Auth Responses
    server.addMockResponse(
      path: '/auth/login',
      method: HttpMethod.post,
      response: '{"token": "mock_token_123", "user_id": "user-123"}',
      delay: const Duration(milliseconds: 500),
    );

    // User Profile
    server.addMockResponse(
      path: '/user/profile',
      method: HttpMethod.get,
      response: '''
      {
        "id": "user-123",
        "name": "Abdelbari Bourgo",
        "email": "abdelbari@bourgoarena.tn",
        "avatar_url": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=2574&auto=format&fit=crop",
        "loyalty_points": 1250,
        "subscription_level": "PREMIUM",
        "subscription_expiry": "2026-12-31",
        "phone": "+216 20 000 000",
        "total_check_ins": 42
      }
      ''',
      delay: const Duration(milliseconds: 300),
    );

    // Activities
    server.addMockResponse(
      path: '/activities',
      method: HttpMethod.get,
      response: '''
      [
        {
          "id": "1",
          "title": "Football 5x5",
          "category": "Outdoor",
          "price": 80.0,
          "currency": "TND",
          "image_url": "https://images.unsplash.com/photo-1574629810360-7efbbe195018?q=80&w=2676&auto=format&fit=crop",
          "icon": "sports_soccer",
          "description": "Premium outdoor turf for 5x5 football matches.",
          "features": ["Artificial Grass", "LED Lighting", "Showers"]
        },
        {
          "id": "2",
          "title": "Padel Court",
          "category": "Outdoor",
          "price": 60.0,
          "currency": "TND",
          "image_url": "https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?q=80&w=2670&auto=format&fit=crop",
          "icon": "sports_tennis",
          "description": "Professional padel courts with panoramic glass.",
          "features": ["Panoramic Glass", "Pro Turf", "Racket Rental"]
        }
      ]
      ''',
      delay: const Duration(milliseconds: 400),
    );

    // Reservations
    server.addMockResponse(
      path: '/reservations',
      method: HttpMethod.get,
      response: '[]', // Start with empty for mock
      delay: const Duration(milliseconds: 300),
    );
  }
}
