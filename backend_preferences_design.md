# User Preferences Backend Design

## Overview
Currently, the mobile application stores user preferences—like language, theme mode, and granular notification toggles—locally on the device using `SharedPreferences`. However, to provide a seamless cross-device experience, these settings need to be tied to the User Profile on the backend. This document outlines the proposed backend changes required to handle saving and loading these preferences.

## 1. Database Schema Updates

The `users` table (or an associated `user_preferences` table) should be extended with a JSON field or dedicated columns to store app and notification settings.

### Recommended Approach: JSON/JSONB Column
Adding a `preferences` column (e.g., JSON in MySQL or JSONB in PostgreSQL) allows maximum flexibility as new notification types are introduced in the future without requiring database migrations.

**Proposed Structure of the `preferences` JSON object:**
```json
{
  "app": {
    "theme": "system", // 'light', 'dark', or 'system'
    "language": "en"   // 'en', 'fr', 'ar', etc.
  },
  "notifications": {
    "push_enabled": true,
    "promotions": true,
    "account_updates": true,
    "reservations": true,
    "subscriptions": true,
    "courses": true,
    "loyalty": true,
    "family": true
  }
}
```

## 2. API Contract Changes

### A. Fetching User Preferences
**Endpoint:** `GET /api/v1/user/profile` (or `GET /api/v1/user/preferences`)
**Response Payload Addition:**
```json
{
  "id": 123,
  "first_name": "John",
  "last_name": "Doe",
  // ... existing fields
  "preferences": {
    "app": {
      "theme": "dark",
      "language": "fr"
    },
    "notifications": {
      "push_enabled": true,
      "promotions": true,
      "account_updates": true,
      "reservations": true,
      "subscriptions": true,
      "courses": true,
      "loyalty": true,
      "family": true
    }
  }
}
```

### B. Updating User Preferences
When the user toggles a setting in the mobile app, it will trigger an update to the backend so the preference is preserved.

**Endpoint:** `PUT /api/v1/user/preferences` (or as part of `PUT /api/v1/user/profile`)
**Request Payload:**
```json
{
  "preferences": {
    "app": {
      "theme": "dark",
      "language": "fr"
    },
    "notifications": {
      "push_enabled": true,
      "promotions": false, // User turned this off
      "account_updates": true,
      "reservations": true,
      "subscriptions": true,
      "courses": true,
      "loyalty": true,
      "family": true
    }
  }
}
```

## 3. Backend Notification Dispatch Logic

The backend system that dispatches push notifications (via Firebase Cloud Messaging) must intercept requests to send notifications and check the target user's `preferences.notifications` settings.

**Pseudocode for Notification Dispatcher:**
```php
function sendPushNotification($user, $notificationType, $payload) {
    $prefs = $user->preferences['notifications'];

    // 1. Check global kill-switch
    if (!$prefs['push_enabled']) {
        return; // Do not send
    }

    // 2. Check granular preference based on type
    if (isset($prefs[$notificationType]) && !$prefs[$notificationType]) {
        return; // User opted out of this specific type
    }

    // 3. Send via FCM
    Firebase::send($user->fcm_token, $payload);
}
```

## 4. Mobile App Sync Flow (Future Implementation)
1. **On Login:** The app fetches `GET /api/v1/user/profile`. The `preferences` object is extracted, and the local `SharedPreferences` are updated. The UI immediately reflects the user's saved language, theme, and notification toggles.
2. **On Toggle Change:** When the user changes a setting in the UI, the app updates local `SharedPreferences` (for instant UI feedback) and simultaneously fires a background `PUT /api/v1/user/preferences` request to sync the change to the server.