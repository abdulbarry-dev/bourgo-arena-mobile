# V1 API Integration Checklist

## Phase 1: UI System Alignment & Component Preparation
- [x] **Task 1.1:** Analyze the existing mobile application UI design system already implemented in the project repository.
- [x] **Task 1.2:** Ensure all new screens and components strictly adhere to this established design language to maintain visual consistency.
- [x] **Task 1.3:** Implement modern UI alignment for all new components (e.g., precise spacing, typography hierarchy, corner radii, and shadow elevations) to match current project standards.

## Phase 2: Home Screen / Services Integration
- [x] **Task 2.1:** Fetch the paginated list of active services using `GET /api/v1/services`.
- [x] **Task 2.2:** Design home screen category cards displaying the service `name`.
- [x] **Task 2.3:** Bind the new `image_url` field to display the category image directly on the card for a rich, professional look.
- [x] **Task 2.4:** Link each card to a detail screen utilizing `GET /api/v1/services/{service}`.

## Phase 3: Course Catalog & Sessions Screens
- [x] **Task 3.1:** Update the fetching logic to distinguish between the catalog and sessions.
- [x] **Task 3.2:** Fetch the Course Catalog using `GET /api/v1/courses`, utilizing the `image_url` property for cover images.
- [x] **Task 3.3:** Link to specific course details using `GET /api/v1/courses/{course}`.
- [x] **Task 3.4:** Fetch upcoming, non-cancelled sessions for a specific course using `GET /api/v1/courses/{course}/sessions`.
- [x] **Task 3.5:** Design the session cards using `start_time`, `end_time`, `title`, and the inherited `course.image_url`.

## Phase 4: Memberships & Plans Selection Screen
- [x] **Task 4.1:** Fetch active subscription plans via `GET /api/v1/plans`.
- [x] **Task 4.2:** Display plan details utilizing the `name`, `description`, `price`, and `billing_cycle` fields.
- [x] **Task 4.3:** Style the plan selection cards to inherit the visual identity of the associated service via the nested `service.image_url` property.
- [x] **Task 4.4:** Implement specific plan detail views using `GET /api/v1/plans/{plan}`.
- [x] **Task 4.5:** Implement the subscription initiation logic by calling `POST /api/v1/subscriptions` with the required `plan_id` payload.
- [x] **Task 4.6:** Implement a UI mechanism allowing authenticated members to cancel active subscriptions using `POST /api/v1/subscriptions/{subscription}/cancel`.

## Phase 5: User Profile / Transaction History Screen
- [x] **Task 5.1:** Build a professional transaction history screen mapping to `GET /api/v1/user/payments`.
- [x] **Task 5.2:** Display the paginated payment list using fields such as `type`, `amount`, `currency`, `status`, `gateway`, `payment_reference`, and `created_at`.

## Phase 6: Authentication, Middleware & Error Handling
- [x] **Task 6.1:** Ensure all calls to `/user/*` and `/subscriptions/*` endpoints include the Bearer token in the `Authorization` header (`auth:sanctum`).
- [x] **Task 6.2:** Upgrade `ApiClient` or equivalent networking layer to catch generic `401 Unauthorized` responses.
- [x] **Task 6.3:** Implement an auto-logout and redirect-to-login sequence upon a `401` response.
- [x] **Task 6.4:** Map backend validation errors (like invalid plan IDs in Phase 4) to user-friendly UI alerts utilizing `ApiErrorHandler`.
