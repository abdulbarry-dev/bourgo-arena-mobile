# API Specification & Backend Requirements

This document defines the RESTful API and database schema for the Bourgo Arena backend, to be implemented using Laravel.

## 1. Overview

The backend serves as the source of truth for user data, activity scheduling, and reservation management. It follows RESTful principles, using standard HTTP methods and JSON for communication.

### General Conventions

- **Base URL**: `https://api.bourgoarena.tn/api`
- **Auth Method**: Bearer Token (Laravel Sanctum or Passport)
- **Versioning**: Not required for initial release; endpoints are prefixed with `/api`.
- **Response Format**: All responses must be JSON objects with consistent keys.

---

## 2. API Endpoints Specification

### Authentication

#### POST `/auth/login`

- **Purpose**: Authenticate user and return a token.
- **Authentication**: None
- **Request Body**:

  ```json
  {
    "email": "user@example.com",
    "password": "securepassword"
  }
  ```

- **Response (200 OK)**:

  ```json
  {
    "token": "sanctum_token_string",
    "user": {
      "id": "uuid",
      "name": "John Doe",
      "email": "user@example.com"
    }
  }
  ```

#### POST `/auth/register`

- **Purpose**: Create a new user account.
- **Authentication**: None
- **Request Body**:

  ```json
  {
    "name": "John Doe",
    "email": "user@example.com",
    "phone": "+21612345678",
    "password": "securepassword",
    "password_confirmation": "securepassword"
  }
  ```

#### GET `/user/profile`

- **Purpose**: Retrieve the current user's profile details and loyalty stats.
- **Authentication**: Required (Bearer)
- **Response (200 OK)**:

  ```json
  {
    "id": "uuid",
    "name": "John Doe",
    "email": "user@example.com",
    "phone": "+21612345678",
    "avatar_url": "https://...",
    "loyalty_points": 150,
    "subscription_level": "Premium",
    "subscription_expiry": "2026-12-31",
    "total_check_ins": 42
  }
  ```

---

### Activities

#### GET `/activities`

- **Purpose**: List all available sports and activities.
- **Authentication**: None or Required (depending on guest policy)
- **Query Parameters**:
  - `category` (optional): Filter by category (e.g., "Fitness", "Soccer").
- **Response (200 OK)**:

  ```json
  [
    {
      "id": "activity-uuid",
      "title": "Evening Yoga",
      "category": "Fitness",
      "price": 25.0,
      "currency": "TND",
      "image_url": "https://...",
      "icon": "yoga_icon",
      "description": "Relaxing evening yoga session.",
      "features": ["Mat included", "Water provided"]
    }
  ]
  ```

#### GET `/activities/{id}`

- **Purpose**: Retrieve detailed information about a specific activity.
- **Authentication**: None

---

### Reservations

#### GET `/reservations`

- **Purpose**: List all reservations for the authenticated user.
- **Authentication**: Required (Bearer)
- **Response (200 OK)**:

  ```json
  [
    {
      "id": "res-uuid",
      "activity_id": "activity-uuid",
      "activity_title": "Evening Yoga",
      "date": "2026-05-10",
      "time": "18:00",
      "duration": "1h",
      "price": 25.0,
      "status": "Confirmed",
      "payment_status": "Paid",
      "qr_code": "data:image/png;base64,..."
    }
  ]
  ```

#### POST `/reservations`

- **Purpose**: Book a new activity.
- **Authentication**: Required (Bearer)
- **Request Body**:

  ```json
  {
    "activity_id": "activity-uuid",
    "date": "2026-05-10",
    "time": "18:00"
  }
  ```

#### DELETE `/reservations/{id}`

- **Purpose**: Cancel a reservation.
- **Authentication**: Required (Bearer)

---

## 3. Data Models (Database Schema)

### Table: `users`

| Field | Type | Constraints |
|---|---|---|
| `id` | UUID | Primary Key |
| `name` | String | Not Null |
| `email` | String | Unique, Not Null |
| `phone` | String | Nullable |
| `password` | String | Hashed |
| `avatar_url` | String | Nullable |
| `loyalty_points` | Integer | Default: 0 |
| `subscription_level` | String | Default: "Free" |
| `subscription_expiry` | Date | Nullable |
| `total_check_ins` | Integer | Default: 0 |
| `timestamps` | - | `created_at`, `updated_at` |

### Table: `activities`

| Field | Type | Constraints |
|---|---|---|
| `id` | UUID | Primary Key |
| `title` | String | Not Null |
| `category` | String | Not Null |
| `price` | Decimal(8,2) | Not Null |
| `currency` | String | Default: "TND" |
| `image_url` | String | Not Null |
| `icon` | String | Not Null |
| `description` | Text | Not Null |
| `features` | JSON | List of features |

### Table: `reservations`

| Field | Type | Constraints |
|---|---|---|
| `id` | UUID | Primary Key |
| `user_id` | UUID | Foreign Key (`users.id`) |
| `activity_id` | UUID | Foreign Key (`activities.id`) |
| `date` | Date | Not Null |
| `time` | Time | Not Null |
| `status` | String | Enum: Pending, Confirmed, Cancelled |
| `payment_status` | String | Enum: Unpaid, Paid, Refunded |
| `qr_code` | Text | Base64 or URL |

---

## 4. Relationships

- **User has many Reservations**: `1:N`
- **Activity has many Reservations**: `1:N`
- **User has one Subscription**: (Represented by fields in the `users` table for simplicity, could be a separate table `subscriptions` in the future).

---

## 5. Business Logic Notes

1. **QR Code Generation**: The backend should generate a unique QR code for each reservation upon confirmation.
2. **Loyalty System**: Users should earn points for every completed reservation (e.g., 10 points per 1 TND spent).
3. **Cancellation Policy**: Reservations cannot be cancelled within 2 hours of the start time.
4. **Concurrency**: Ensure that overlapping reservations for the same user or over-capacity for an activity are prevented.

---

## 6. Assumptions / Open Questions

- **Payment Integration**: Assumed to be handled via a separate payment gateway (e.g., Stripe, GPG); the backend just updates `payment_status`.
- **Capacity Management**: Not explicitly detailed in the current frontend; the backend should likely track max capacity per activity.
- **Images**: Assumed to be stored in an S3 bucket or similar; API returns absolute URLs.
