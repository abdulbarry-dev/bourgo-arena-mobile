# Backend API Alignment for Flutter Web (Local/Testing)

This document outlines the necessary changes required on the Laravel backend to allow the Flutter Web platform to successfully authenticate and use the API during local development and testing, while remaining secure in production.

## The Problem
Currently, when the Flutter app runs on the web, it sends the following payload to `POST /api/v1/device/register`:
```json
{
  "device_id": "uuid-v4-string",
  "platform": "web", 
  "app_version": "1.0.0",
  "integrity_token": "" 
}
```
The Laravel backend responds with a `422 Unprocessable Content`. Because this initial registration fails, the Flutter app has no device token, resulting in `401 Unauthenticated` errors for all subsequent API calls.

## The Solution
The backend's validation rules for device registration must be updated to conditionally accept the `'web'` platform and an empty `integrity_token`, **only** when the environment is `local` or `testing`.

### Required Backend Changes

Locate your device registration logic (e.g., `app/Http/Controllers/DeviceRegistrationController.php` or `app/Http/Requests/RegisterDeviceRequest.php`).

#### 1. Conditionally Allow the 'web' Platform
Update the validation rules to dynamically construct the allowed platforms array.

```php
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\App;

// Determine allowed platforms based on environment
$allowedPlatforms = ['android', 'ios'];
if (App::environment(['local', 'testing'])) {
    $allowedPlatforms[] = 'web';
}

$rules = [
    'device_id'   => ['required', 'string'],
    'platform'    => ['required', 'string', Rule::in($allowedPlatforms)],
    'app_version' => ['required', 'string'],
    // ...
];
```

#### 2. Make Integrity Token Conditionally Required
The integrity token should be required for mobile platforms but nullable for the web platform.

```php
$rules['integrity_token'] = [
    Rule::requiredIf(fn () => request('platform') !== 'web'),
    'string',
    'nullable',
];
```

#### 3. Bypass Cryptographic Verification
Ensure that the actual cryptographic verification logic (e.g., calling Google Play Integrity or Apple App Attest APIs) is bypassed for the web platform.

```php
// Inside your controller or service logic:
if ($validated['platform'] !== 'web') {
    // Perform standard integrity checks
    $this->integrityService->verify($validated['integrity_token'], $validated['platform']);
}
```

## Verification
1. Apply these changes to your Laravel repository.
2. Clear the config cache: `php artisan config:clear`
3. Run the Flutter web app locally.
4. Inspect the Network tab: `POST /api/v1/device/register` should now return a `200 OK` with a token. Subsequent calls to endpoints like `/events` or `/courses` will use this token and succeed.
