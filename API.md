# Bourgo Arena API Specification

This document provides a comprehensive specification for the backend API serving the Bourgo Arena mobile application. It is designed for a Laravel developer to implement the complete backend service from scratch.

---

## 1. Overview

The Bourgo Arena API is a RESTful service that facilitates authentication, user profile management, activity browsing, bookings, and notifications for the Bourgo Arena mobile app. The API acts as the central orchestrator for business logic, ensuring data consistency and secure access to arena resources.

* **Base URL**: `http://localhost:8000/api/v1`
* **Authentication**: Bearer token via `Authorization: Bearer <token>` header.
* **Content Type**: `application/json` for all requests and responses.
* **Versioning Strategy**: URI versioning (`/v1/`).

---

## 2. Architecture & Laravel Recommendations

To maintain alignment with the mobile app's architecture and performance requirements, the following Laravel setup is recommended:

* **Project Structure**: Standard Laravel 11+ layout using Controllers, FormRequests for validation, API Resources for response transformation, and Eloquent Models.
* **Authentication**: **Laravel Sanctum**. Use token-based authentication (not session-based) to match the mobile client's stateless nature.
* **Middleware Stack**:
  * `auth:sanctum`: Protect all user-specific and booking routes.
  * `throttle:api`: Apply rate limiting to all endpoints to prevent abuse.
* **Recommended Folder Layout**:

    ```
    app/
    ├── Http/
    │   ├── Controllers/Api/V1/   # Versioned controllers
    │   ├── Requests/             # FormRequests for validation
    │   └── Resources/            # API Resources for JSON transformation
    ├── Models/                   # Eloquent Models
    └── Policies/                 # Authorization logic (e.g., cancelling own booking)
    routes/
    └── api.php                   # All API routes defined here
    ```

The API uses a state-driven authentication flow to guide users through required steps. Both email AND phone verification are mandatory for full access.

**Possible States (`state` field):**
* `pending_verification`: User has just registered or logged in. No methods have been verified yet.
* `pending_additional_verification`: User has verified one method (email OR phone) but must verify the remaining one. A token with `verification` ability is issued. Note: Users can choose to skip this secondary verification and proceed to onboarding.
* `pending_onboarding`: At least one method is verified (or both) and the user has proceeded to profile setup. User must complete profile setup (PIN, family members, etc.). A token with `onboarding` ability is issued.
* `active`: Fully authenticated and onboarded; full access allowed. Token has `*` ability.

**Verification Transition Flow:**
```
Register/Login
    ↓
pending_verification (No methods verified)
    ↓
User verifies first method (email OR phone)
    ↓
pending_additional_verification (Token with 'verification' ability issued)
    ↓
User verifies second method (or opts to SKIP)
    ↓
pending_onboarding (Token with 'onboarding' ability issued)
    ↓
User completes profile (PIN, etc.)
    ↓
active (Token with '*' ability issued)
```

---

## 3. Global Response Envelope

All API responses must follow a consistent JSON structure.

### Success Response

```json
{
  "success": true,
  "data": { ... }, 
  "message": "Operation successful"
}
```

*Note: If the result is a list, `data` should be a JSON array.*



### Error Response

```json
{
  "success": false,
  "message": "Human-readable error description",
  "errors": {
    "field_name": ["Specific validation error message"]
  }
}
```

### Standard HTTP Status Codes

* `200 OK`: Successful request.
* `201 Created`: Successful creation (e.g., booking).
* `400 Bad Request`: General client-side error.
* `401 Unauthorized`: Missing or invalid Bearer token.
* `403 Forbidden`: Authenticated but lacks permission for the resource.
* `404 Not Found`: Resource does not exist.
* `422 Unprocessable Entity`: Validation failed (include `errors` object).
* `429 Too Many Requests`: Rate limit exceeded.
* `500 Internal Server Error`: Unexpected server-side failure.

---

## 4. Authentication Endpoints

### POST /auth/login

* **Description**: Authenticates a user and returns their current state.
* **Auth Required**: No
* **Request Body**:
  * `email` (string, required, email) OR `phone` (string, required)
  * `password` (string, required)
* **Success Response**:

    ```json
    {
      "success": true,
      "data": {
        "token": "sanctum_token_string_here",
        "state": "active",
        "code": null,
        "user": { ... },
        "verification_status": {
          "email_verified": true,
          "phone_verified": true,
          "email": "user@example.com",
          "phone": "+212600000000",
          "unverified_method": null
        }
      }
    }
    ```

* **Notes**: 
  * If state is `pending_verification`, `token` is omitted and `code` is `EMAIL_NOT_VERIFIED`.
  * If state is `pending_additional_verification`, `token` is issued with `verification` ability and `code` is `ADDITIONAL_VERIFICATION_REQUIRED`.
  * If state is `pending_onboarding`, `token` is issued with `onboarding` ability.

* **Error Responses**:
  * `401`: Invalid credentials.
  * `422`: Validation error.
* **Laravel Note**: `AuthController@login`, `LoginRequest`.

### POST /auth/register

* **Description**: Creates a new user account.
* **Auth Required**: No
* **Request Body**:
  * `name` (string, required): Full name (First + Last).
  * `email` (string, required, email, unique:users)
  * `phone` (string, required)
  * `gender` (string, required, in: male,female,other)
  * `date_of_birth` (string, required, format: YYYY-MM-DD)
  * `password` (string, required, min:8)
  * `password_confirmation` (string, required)
  * `is_family_account` (boolean, optional, default: false)
* **Success Response**: 
    ```json
    {
      "success": true,
      "data": {
        "state": "pending_verification",
        "user": { ... },
        "verification_status": {
          "email_verified": false,
          "phone_verified": false,
          "email": "user@example.com",
          "phone": "+212600000000",
          "unverified_method": "email"
        }
      }
    }
    ```
* **Laravel Note**: `AuthController@register`, `RegisterRequest`. Generates an initial OTP for the registration identifier.

### POST /auth/logout

* **Description**: Revokes the current session token.
* **Auth Required**: Yes
* **Success Response**: `{"success": true, "message": "Logged out"}`
* **Laravel Note**: `AuthController@logout`. Uses `$user->currentAccessToken()->delete()`.

### POST /auth/send-otp

* **Description**: Sends a one-time password to a phone or email.
* **Auth Required**: No
* **Request Body**:
  * `identifier` (string, required): Email or Phone number.
* **Success Response**: `{"success": true, "message": "OTP sent"}`

### POST /auth/verify-otp

* **Description**: Verifies the OTP code for either email or phone.
* **Auth Required**: No
* **Request Body**:
  * `identifier` (string, required): Email or Phone number.
  * `otp` (string, required, length:6)
* **Success Response**:

    ```json
    {
      "success": true,
      "data": {
        "valid": true,
        "token": "...",
        "state": "pending_additional_verification",
        "user": { ... },
        "verification_status": {
          "email_verified": true,
          "phone_verified": false,
          "email": "user@example.com",
          "phone": "+212600000000",
          "unverified_method": "phone"
        }
      }
    }
    ```

* **Notes**: 
  * If only one method is verified, `state` is `pending_additional_verification` and the `token` has the `verification` ability.
  * If both methods are verified but onboarding is incomplete, `state` is `pending_onboarding` and the `token` has the `onboarding` ability.
  * If all steps are complete, `state` is `active` and the `token` has the `*` ability.

### POST /auth/skip-additional-verification

* **Description**: Allows the user to explicitly skip the secondary verification method and move directly to the onboarding phase.
* **Auth Required**: Yes (token with `verification` ability)
* **Success Response**:

    ```json
    {
      "success": true,
      "data": {
        "state": "pending_onboarding",
        "token": "..."
      }
    }
    ```

* **Notes**: Issues a new token with the `onboarding` ability.

### POST /user/verify-email

* **Description**: Verifies a user's email address via OTP. Used during `pending_additional_verification`.
* **Auth Required**: Yes (token with `verification` ability)
* **Request Body**:
  * `email` (string, required)
  * `otp` (string, required, length:6)
* **Success Response**:

    ```json
    {
      "success": true,
      "data": {
        "valid": true,
        "state": "pending_onboarding",
        "verification_status": {
          "email_verified": true,
          "phone_verified": true,
          "email": "user@example.com",
          "phone": "+212600000000",
          "unverified_method": null
        }
      }
    }
    ```

* **Notes**: Successful verification updates the current token's abilities (e.g., from `verification` to `onboarding`).

### POST /user/verify-phone

* **Description**: Verifies a user's phone number via OTP. Used during `pending_additional_verification`.
* **Auth Required**: Yes (token with `verification` ability)
* **Request Body**:
  * `phone` (string, required)
  * `otp` (string, required, length:6)
* **Success Response**: Same structure as `/user/verify-email`

* **Note:** For all verify endpoints (`/auth/verify-otp`, `/user/verify-email`, `/user/verify-phone`), the backend must return `"valid": true` alongside the updated `state` and `token` upon successful OTP validation. And the API must issue tokens for the next step of the authentication state flow (e.g. `pending_additional_verification` issues a token with the `verification` ability to hit `/user/verify-email` or `/user/verify-phone`).

### GET /user/verification-status

* **Description**: Retrieves the current verification status for the authenticated user.
* **Auth Required**: Yes
* **Success Response**:

    ```json
    {
      "success": true,
      "data": {
        "email_verified": true,
        "phone_verified": false,
        "email": "user@example.com",
        "phone": "+212600000000",
        "unverified_method": "phone"
      }
    }
    ```

### POST /auth/request-family-otp

* **Description**: Requests an OTP specifically for enabling family mode.
* **Auth Required**: Yes
* **Success Response**: `{"success": true}`

### POST /auth/complete-registration

* **Description**: Finalizes profile data during the registration flow.
* **Auth Required**: No (or temporary token)
* **Request Body**:
  * `name` (string, required)
  * `email` (string, required)
  * `phone` (string, required)
  * `gender` (string, required)
  * `date_of_birth` (string, required, format: YYYY-MM-DD)
  * `is_parent_account` (boolean, required)
  * `pin` (string, required, length:4)
* **Success Response**: `{"success": true, "data": {"token": "...", "state": "active"}}`

---

## 5. User Endpoints

### GET /user/profile

* **Description**: Retrieves the authenticated user's full profile, including children.
* **Auth Required**: Yes
* **Success Response**:

    ```json
    {
      "success": true,
      "data": {
        "id": "user_uuid",
        "state": "active",
        "name": "John Doe",
        "email": "john@example.com",
        "phone": "+212600000000",
        "avatar_url": "https://...",
        "loyalty_points": 150,
        "subscription_level": "Premium",
        "subscription_expiry": "2024-12-31",
        "total_check_ins": 42,
        "birth_date": "1990-01-01",
        "is_parent_account": true,
        "children": [
          {
            "id": "child_uuid",
            "first_name": "Jane",
            "last_name": "Doe",
            "birth_date": "2015-05-20",
            "gender": "female",
            "avatar_url": null
          }
        ]
      }
    }
    ```

### PUT /user/profile

* **Description**: Updates user profile information.
* **Auth Required**: Yes
* **Request Body**: Same fields as profile `data` (excluding `id`, `loyalty_points`, etc.).
* **Laravel Note**: `UserProfileController@update`, `UpdateProfileRequest`.

### PUT /user/password

* **Description**: Updates the user's password.
* **Auth Required**: Yes
* **Request Body**:
  * `current_password` (string, required)
  * `new_password` (string, required, min:8)
  * `new_password_confirmation` (string, required)

### GET /user/access-history

* **Description**: Returns the authenticated user's access/check-in history for the profile history screen.
* **Auth Required**: Yes
* **Success Response**:

    ```json
    {
      "success": true,
      "data": [
        {
          "id": "acc_001",
          "checked_in_at": "2026-05-14T09:42:00Z",
          "location": "Main Entrance"
        },
        {
          "id": "acc_002",
          "checked_in_at": "2026-05-13T17:15:00Z",
          "location": "Gym Gate"
        }
      ]
    }
    ```

* **Notes for the Flutter app**:
  * The `HistoryScreen` access tab should fetch this endpoint on load instead of using the current mock list.
  * When the returned `data` array is empty, the app should show the empty state copy for access history.
  * The existing `GET /user/profile` response can continue exposing `total_check_ins`, but it does not replace this endpoint because the UI needs individual history rows.

---

## 6. Activity Endpoints

### GET /activities

* **Description**: Lists all sport activities (Football, Padel, etc.).
* **Auth Required**: No
* **Success Response**: Array of `ActivityModel`.

    ```json
    {
      "success": true,
      "data": [
        {
          "id": "1",
          "title": "Football 5x5",
          "category": "Sport",
          "base_price": 250.0,
          "currency": "MAD",
          "image_url": "...",
          "icon": "sports_soccer",
          "description": "...",
          "features": ["Artificial Grass", "Showers"],
          "rating": 4.8,
          "review_count": 120
        }
      ]
    }
    ```

### GET /activities/{id}

* **Description**: Detail of a specific activity.

### GET /activities/{id}/slots

* **Description**: Retrieves available time slots for a specific activity.
* **Success Response**:

    ```json
    {
      "success": true,
      "data": [
        {
          "id": "101",
          "time": "09:00",
          "available": true
        },
        {
          "id": "102",
          "time": "10:00",
          "available": false
        }
      ]
    }
    ```

---

## 7. Booking / Reservation Endpoints

### GET /reservations

* **Description**: List of the authenticated user's reservations.
* **Auth Required**: Yes
* **Success Response**: Array of `ReservationModel`.

    ```json
    {
      "success": true,
      "data": [
        {
          "id": "res_123",
          "activity_id": "1",
          "activity_title": "Football 5x5",
          "date": "2024-06-15",
          "time": "18:00",
          "duration": "60 min",
          "price": 250.0,
          "status": "confirmed",
          "payment_status": "paid",
          "qr_code": "data:image/png;base64,..."
        }
      ]
    }
    ```

### POST /reservations

* **Description**: Creates a new booking.
* **Auth Required**: Yes
* **Request Body**:
  * `activity_id` (string, required)
  * `activity_slot_id` (string, required)
  * `date` (string, required, format: YYYY-MM-DD)
  * `time` (string, required, format: HH:mm)
  * `duration` (string, required)
  * `price` (double, required)

### DELETE /reservations/{id}

* **Description**: Cancels a booking.
* **Auth Required**: Yes

---

## 8. Course Endpoints

### GET /courses

* **Description**: Lists available training sessions and academy courses.
* **Success Response**: Array of `CourseModel`.

    ```json
    {
      "id": "c1",
      "title": "Karate Kids",
      "instructor": "Sensei Omar",
      "start_time": "17:00",
      "end_time": "18:30",
      "day_of_week": 1,
      "category": "Academy",
      "capacity": 20,
      "enrolled": 15,
      "icon": "sports_martial_arts"
    }
    ```

---

## 9. Notification Endpoints

### GET /notifications

* **Description**: Retrieves user notifications.
* **Auth Required**: Yes
* **Success Response**: Array of `NotificationModel`.

    ```json
    {
      "id": "n1",
      "title": "Booking Confirmed",
      "message": "Your football match is scheduled for tomorrow.",
      "timestamp": "2024-06-14T10:00:00Z",
      "type": "booking",
      "is_read": false
    }
    ```

---

## 10. Settings Endpoints

The following settings are **local-only** (stored via `SharedPreferences`) and do not require server endpoints:

* `settings_theme_mode` (Light/Dark/System)
* `settings_locale` (Language preference)
* `settings_notifications_enabled` (App-level toggle)

---

The Laravel API must return specific HTTP status codes based on the error type encountered. Many responses also include a `code` field to help the client handle specific business logic states.

| Backend Scenario | HTTP Status | `code` (if applicable) | Flutter `Failure` |
| :--- | :--- | :--- | :--- |
| Invalid token or missing auth | `401` | - | `AuthFailure` |
| Email/Phone not verified | `403` | `EMAIL_NOT_VERIFIED` | `AuthFailure` |
| One method verified, one pending | `403` | `ADDITIONAL_VERIFICATION_REQUIRED` | `AuthFailure` |
| Onboarding incomplete | `403` | `ONBOARDING_INCOMPLETE` | `AuthFailure` |
| Permission denied (Policy fail) | `403` | - | `AuthFailure` |
| Resource not found | `404` | - | `NotFoundFailure` |
| Validation failed | `422` | - | `ValidationFailure` |
| Server failure | `500` | - | `ServerFailure` |

---

## 12. Laravel Route File (`routes/api.php`)

```php
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\V1\AuthController;
use App\Http\Controllers\Api\V1\UserController;
use App\Http\Controllers\Api\V1\ActivityController;
use App\Http\Controllers\Api\V1\ReservationController;
use App\Http\Controllers\Api\V1\CourseController;
use App\Http\Controllers\Api\V1\NotificationController;

Route::prefix('v1')->group(function () {
    
    // Public Auth Routes
    Route::prefix('auth')->group(function () {
        Route::post('/login', [AuthController::class, 'login']);
        Route::post('/register', [AuthController::class, 'register']);
        Route::post('/send-otp', [AuthController::class, 'sendOtp']);
        Route::post('/verify-otp', [AuthController::class, 'verifyOtp']);
        Route::post('/complete-registration', [AuthController::class, 'completeRegistration']);
    });

    // Public Browsing Routes
    Route::get('/activities', [ActivityController::class, 'index']);
    Route::get('/activities/{activity}', [ActivityController::class, 'show']);
    Route::get('/activities/{activity}/slots', [ActivityController::class, 'slots']);
    Route::get('/courses', [CourseController::class, 'index']);

    // Protected Routes
    Route::middleware('auth:sanctum')->group(function () {
        
        Route::post('/auth/logout', [AuthController::class, 'logout']);
        Route::post('/auth/request-family-otp', [AuthController::class, 'requestFamilyOtp']);

        Route::prefix('user')->group(function () {
            Route::get('/profile', [UserController::class, 'profile']);
            Route::put('/profile', [UserController::class, 'updateProfile']);
            Route::put('/password', [UserController::class, 'updatePassword']);
            
            // New verification endpoints
            Route::get('/verification-status', [AuthController::class, 'verificationStatus']);
            Route::post('/verify-email', [AuthController::class, 'verifyEmail']);
            Route::post('/verify-phone', [AuthController::class, 'verifyPhone']);
        });

        Route::apiResource('reservations', ReservationController::class)->only(['index', 'store', 'destroy']);
        
        Route::get('/notifications', [NotificationController::class, 'index']);
    });
});
```

---

## 13. Database Schema Hints

* **User**: `id`, `name`, `email`, `phone`, `avatar_url`, `loyalty_points`, `subscription_level`, `subscription_expiry`, `total_check_ins`, `birth_date`, `is_parent_account`.
  * *Relations*: `hasMany(Reservation)`, `hasMany(ChildProfile)`.
* **ChildProfile**: `id`, `user_id`, `first_name`, `last_name`, `birth_date`, `gender`, `avatar_url`.
  * *Relations*: `belongsTo(User)`.
* **Activity**: `id`, `title`, `category`, `base_price`, `currency`, `image_url`, `icon`, `description`, `features` (JSON), `rating`, `review_count`.
  * *Relations*: `hasMany(TimeSlot)`.
* **Reservation**: `id`, `user_id`, `activity_id`, `activity_title`, `date`, `time`, `duration`, `price`, `status`, `payment_status`, `qr_code`.
  * *Relations*: `belongsTo(User)`, `belongsTo(Activity)`.
* **Course**: `id`, `title`, `instructor`, `start_time`, `end_time`, `day_of_week`, `category`, `capacity`, `enrolled`, `icon`.
* **Notification**: `id`, `user_id`, `title`, `message`, `timestamp`, `type`, `is_read`.

---

## 15. Search Endpoints

### GET /search

* **Description**: Search for activities and courses.
* **Auth Required**: No
* **Query Parameters**:
  * `q` (string, required): Search query (min 2 characters).
* **Success Response**: Array of search results.

    ```json
    {
      "success": true,
      "data": [
        {
          "id": "1",
          "type": "activity",
          "title": "Football 5x5",
          "subtitle": "Sport",
          "icon": "sports_soccer"
        },
        {
          "id": "c1",
          "type": "course",
          "title": "Karate Kids",
          "subtitle": "Sensei Omar",
          "icon": "sports_martial_arts"
        }
      ]
    }
    ```

---

## 16. Family Management Endpoints

### GET /family/children

* **Description**: List all children profiles managed by the authenticated parent.
* **Auth Required**: Yes
* **Success Response**: Array of `MemberResource` objects.

### POST /family/children

* **Description**: Add a new child profile to the family account.
* **Auth Required**: Yes
* **Request Body**:
  * `first_name` (string, required)
  * `last_name` (string, required)
  * `birth_date` (string, required, format: YYYY-MM-DD)
  * `gender` (string, required, in: male,female)
* **Success Response**: `201 Created` with the new child object.

### DELETE /family/children/{id}

* **Description**: Remove a child profile.
* **Auth Required**: Yes

---

## 17. Subscription & Device Endpoints

### GET /member/subscription

* **Description**: Get the current active subscription details for the member.
* **Auth Required**: Yes
* **Success Response**: Subscription details or `null`.

### POST /device-token

* **Description**: Register or update a device token for push notifications (FCM/OneSignal).
* **Auth Required**: Yes
* **Request Body**:
  * `token` (string, required)
  * `platform` (string, optional, e.g., android, ios)

---

## 18. Implementation Checklist

1. [x] **Infrastructure**: Install Laravel + Sanctum.
2. [x] **Models**: Create all Eloquent models and migrations.
3. [x] **Validation**: Create `FormRequests` with strict rules.
4. [x] **Transformation**: Create `API Resources` to ensure `snake_case` field names.
5. [x] **Controllers**: Implement logic for OTP and Sanctum token management.
6. [x] **Routes**: Register all routes in `api.php`.
7. [ ] **Testing**: Write feature tests for the complete Auth flow and Reservation logic.
8. [ ] **CORS**: Ensure `config/cors.php` allows requests from the mobile app.
