// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Bourgo Arena';

  @override
  String get tagline => 'The Sport HQ in Djerba';

  @override
  String get onboardingTitle => 'PUSH YOUR LIMITS';

  @override
  String get onboardingSubtitle =>
      'Experience the ultimate sport performance center in the heart of Djerba.';

  @override
  String get commonRetry => 'RETRY';

  @override
  String get commonLoadingError => 'Loading Error';

  @override
  String get commonNoResults => 'NO RESULTS';

  @override
  String get commonNoResultsSubtitle =>
      'We couldn\'t find anything for your search. Try other filters.';

  @override
  String get commonOfflineTitle => 'OFFLINE MODE';

  @override
  String get commonOfflineSubtitle =>
      'Oops! It seems you are disconnected. Check your internet connection to continue.';

  @override
  String get commonOfflineAccess => 'ACCESS OFFLINE RESERVATIONS';

  @override
  String get commonRequiredField => 'Required field';

  @override
  String get commonStart => 'START';

  @override
  String get commonAppNamePart1 => 'BOURGO';

  @override
  String get commonAppNamePart2 => 'ARENA';

  @override
  String get commonLoadingFailed => 'Failed to load data. Please try again.';

  @override
  String get commonGenderMale => 'Male';

  @override
  String get commonGenderFemale => 'Female';

  @override
  String get commonErrorOccurred => 'An error occurred. Please try again.';

  @override
  String get commonSave => 'SAVE';

  @override
  String get commonMissingContactInfo => 'Missing contact information.';

  @override
  String get commonImagePickerPlaceholder => 'Image picker would open here';

  @override
  String get commonMe => 'Me';

  @override
  String get commonSetUp => 'SET UP';

  @override
  String get commonPointsShort => 'pts';

  @override
  String get guestBrowse => 'CONTINUE AS GUEST';

  @override
  String get navHome => 'HOME';

  @override
  String get navActivities => 'BROWSE';

  @override
  String get navPlanning => 'PLANNING';

  @override
  String get navProfile => 'ACCOUNT';

  @override
  String get homeHeroPart1 => 'JOIN THE';

  @override
  String get homeHeroPart2 => 'ARENA';

  @override
  String get homeTicker =>
      'RESERVE YOUR SESSION • FOOTBALL • PADEL • FITNESS • ';

  @override
  String get homeNoCourses => 'No courses scheduled for today.';

  @override
  String get homeActivitiesTitle => 'OUR ACTIVITIES';

  @override
  String get homeActivitiesEmpty => 'No activities available.';

  @override
  String get homeActivitiesEmptySubtitle =>
      'Check back later for new sports and activities.';

  @override
  String get homeSeeAll => 'SEE ALL';

  @override
  String get homeTodayTitle => 'TODAY';

  @override
  String get activitiesExplorer => 'BROWSE SPORTS';

  @override
  String get activitiesMyReservations => 'MY RESERVATIONS';

  @override
  String get activitiesNoReservations => 'No reservations found.';

  @override
  String get activitiesNoReservationsSubtitle =>
      'Ready to play? Book your first session now and join the arena!';

  @override
  String get activitiesNoReservationsCTA => 'BOOK A SESSION';

  @override
  String get activitiesNoSportsFound => 'No sports found.';

  @override
  String get activitiesNoSportsFoundSubtitle =>
      'Try again later or explore a different category.';

  @override
  String get activitiesRetry => 'RETRY';

  @override
  String get activitiesStatusConfirmed => 'CONFIRMED';

  @override
  String get activitiesStatusPending => 'PENDING';

  @override
  String get activitiesStatusCancelled => 'CANCELLED';

  @override
  String get authLogin => 'LOG IN';

  @override
  String get authRegister => 'SIGN UP';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authNoAccount => 'Don\'t have an account? ';

  @override
  String get authHaveAccount => 'Already have an account? ';

  @override
  String get authEmailHint => 'Enter your identifier';

  @override
  String get authPasswordHint => 'Enter your password';

  @override
  String get authIdentifierLabel => 'Email or Phone';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authDeletionCancelSubtitle =>
      'Your account is set to be deleted. Enter the code sent to your email/phone to cancel this request.';

  @override
  String get authRememberMe => 'Remember me';

  @override
  String get authLoginTitle => 'Login';

  @override
  String get authLoginSubtitle => 'Welcome back! Log in to continue.';

  @override
  String get authRegisterTitle => 'Registration';

  @override
  String get authRegisterSubtitle =>
      'Join the Sport HQ in Djerba and start your adventure.';

  @override
  String get authFullNameLabel => 'Full Name';

  @override
  String get authFullNameHint => 'Enter your name';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailLabelHint => 'Enter your email';

  @override
  String get authPhoneLabel => 'Phone';

  @override
  String get authPhoneHint => 'Enter your number';

  @override
  String get authPasswordCreateHint => 'Create a password';

  @override
  String get authPasswordMinLength => 'Min 6 characters';

  @override
  String get authForgotPasswordTitle => 'Forgot Password';

  @override
  String get authForgotPasswordSubtitle =>
      'Don\'t worry! Enter your email or number to receive a code.';

  @override
  String get authVerificationTitle => 'VERIFICATION';

  @override
  String get authOtpSubtitlePrefix => 'Enter the 6-digit code sent to ';

  @override
  String get authOtpSubtitleDefault => 'your number';

  @override
  String authOtpResendTimer(Object seconds) {
    return 'Resend code in ${seconds}s';
  }

  @override
  String get authNewPasswordTitle => 'New Password';

  @override
  String get authNewPasswordSubtitle =>
      'Create a new secure password for your account.';

  @override
  String get authNewPasswordLabel => 'New Password';

  @override
  String get authNewPasswordHint => 'Enter new password';

  @override
  String get authConfirmPasswordLabel => 'Confirm Password';

  @override
  String get authConfirmPasswordHint => 'Repeat the password';

  @override
  String get authPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get authSendCode => 'SEND CODE';

  @override
  String get authVerify => 'VERIFY';

  @override
  String get authReset => 'RESET';

  @override
  String get profilePoints => 'BOURGO POINTS';

  @override
  String get profileCheckins => 'VISITS';

  @override
  String get profileMySubscription => 'Membership Plan';

  @override
  String get profileHistory => 'Access & History';

  @override
  String get profileDeleteAccount => 'Delete Account';

  @override
  String get profileDeleteAccountTitle => 'Delete Account';

  @override
  String get profileDeleteAccountSubtitle => 'This action is permanent';

  @override
  String get profileDeleteAccountMessage =>
      'Are you sure you want to delete your account? This action cannot be undone and your account will be processed for deletion.';

  @override
  String get profileDeleteAccountConfirm => 'Delete My Account';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileLogout => 'SIGN OUT';

  @override
  String get profileSubscriptionTitle => 'MY PLAN';

  @override
  String get profileManageSubscription => 'MANAGE PLAN';

  @override
  String get profileAdvantages => 'PRIVILEGES';

  @override
  String get profileNextBilling => 'NEXT BILLING';

  @override
  String get profileMonthlyUsage => 'Monthly usage';

  @override
  String get profilePlanLabel => 'PLAN';

  @override
  String get months => 'months';

  @override
  String get profileBenefit1 => 'Unlimited gym access';

  @override
  String get profileBenefit2 => 'Priority court reservation';

  @override
  String get profileBenefit3 => '1 free guest per month';

  @override
  String get profileBenefit4 => '-10% at the Pro Shop';

  @override
  String get profileHistoryTitle => 'ACCESS & HISTORY';

  @override
  String get profileTabCheckin => 'ACCESS';

  @override
  String get profileTabHistory => 'HISTORY';

  @override
  String get profileQrSubtitle => 'PRESENT YOUR QR CODE';

  @override
  String get profileQrPlaceholder => 'BOURGO-SCAN-123';

  @override
  String get profileQrScanInstruction =>
      'Scan this code at the entrance to validate your presence.';

  @override
  String get profileAccessMethods => 'ACCESS METHODS';

  @override
  String get profileAccessPin => 'Security PIN';

  @override
  String get profileStatusConfigured => 'Configured';

  @override
  String get profileStatusNotConfigured => 'Not set';

  @override
  String get profileCheckinHistory => 'CHECK-IN HISTORY';

  @override
  String get profileCheckinEntry => 'Entry recorded';

  @override
  String get profileNoCheckins => 'No access history yet.';

  @override
  String get profileNoCheckinsSubtitle =>
      'Your check-ins will appear here once you enter the arena.';

  @override
  String get profileNoHistory => 'No past reservations.';

  @override
  String get profileNoHistorySubtitle =>
      'Your past activities and sessions will appear here once you complete them.';

  @override
  String get planningTitle => 'CLASS SCHEDULE';

  @override
  String get planningFilterTitle => 'FILTER BY CATEGORY';

  @override
  String get planningNoCourses => 'No classes scheduled for this day.';

  @override
  String get planningNoCoursesSubtitle =>
      'Try selecting another day of the week or a different category to find available sessions.';

  @override
  String get bookingTitle => 'RESERVATION';

  @override
  String get bookingSuccess => 'RESERVATION SUCCESSFUL!';

  @override
  String get bookingConfirmed => 'RESERVATION CONFIRMED!';

  @override
  String get bookingReturnHome => 'RETURN TO HOME';

  @override
  String get bookingNoSlots => 'No slots available for this date.';

  @override
  String get bookingPay => 'PAY';

  @override
  String get bookingStepMember => 'MEMBER';

  @override
  String get bookingMemberSelectSubtitle =>
      'Select a profile for pricing and eligibility.';

  @override
  String get bookingDateLabel => 'DATE & TIME';

  @override
  String get bookingLocationLabel => 'LOCATION';

  @override
  String get bookingSummaryTitle => 'SUMMARY';

  @override
  String get bookingPaymentTitle => 'PAYMENT';

  @override
  String get bookingDate => 'Date';

  @override
  String get bookingTime => 'Time Slot';

  @override
  String get bookingDuration => 'Duration';

  @override
  String get bookingDurationPadel => '90 min';

  @override
  String get bookingDurationStandard => '60 minutes';

  @override
  String get bookingMethodCard => 'Credit Card';

  @override
  String get bookingMethodWallet => 'Bourgo Pay Balance';

  @override
  String get bookingTotal => 'TOTAL';

  @override
  String get bookingConfirm => 'CONFIRM';

  @override
  String get bookingCurrency => 'TND';

  @override
  String get bookingToPay => 'TND (To pay)';

  @override
  String get bookingSuccessMessagePrefix => 'Your ';

  @override
  String get bookingSuccessMessageSuffix =>
      ' court has been reserved successfully.';

  @override
  String get bookingSportDefault => 'Sport';

  @override
  String get bookingLocationValue => 'Bourgo Arena, Djerba';

  @override
  String get bookingTodayAt => 'Today at 18:30';

  @override
  String get commonMon => 'MON';

  @override
  String get commonTue => 'TUE';

  @override
  String get commonWed => 'WED';

  @override
  String get commonThu => 'THU';

  @override
  String get commonFri => 'FRI';

  @override
  String get commonSat => 'SAT';

  @override
  String get commonSun => 'SUN';

  @override
  String get notificationsTitle => 'NOTIFICATIONS';

  @override
  String get notificationsMarkAllRead => 'MARK ALL READ';

  @override
  String get notificationsEmpty => 'No notifications for now.';

  @override
  String get notificationsEmptySubtitle =>
      'We\'ll let you know here when you have a new reservation or a special offer.';

  @override
  String get planningCategoryAll => 'All';

  @override
  String get planningCategoryFitness => 'Fitness';

  @override
  String get planningCategoryAcademy => 'Academy';

  @override
  String get planningCategoryWellness => 'Wellness';

  @override
  String get bookingStepSport => 'SPORT';

  @override
  String get bookingStepDetails => 'DETAILS';

  @override
  String get bookingStepTime => 'TIME';

  @override
  String get bookingStepPayment => 'PAYMENT';

  @override
  String get settingsTitle => 'SETTINGS';

  @override
  String get settingsSectionAccount => 'ACCOUNT';

  @override
  String get settingsSectionPreferences => 'PREFERENCES';

  @override
  String get settingsSectionLegal => 'LEGAL';

  @override
  String get settingsSectionAbout => 'ABOUT';

  @override
  String get settingsEditProfile => 'Edit Profile';

  @override
  String get settingsManageFamily => 'Manage Family';

  @override
  String get settingsChangePassword => 'Change Password';

  @override
  String get settingsLanguage => 'App Language';

  @override
  String get settingsTheme => 'Display Mode';

  @override
  String get settingsThemeSystem => 'System Default';

  @override
  String get settingsThemeLight => 'Light Mode';

  @override
  String get settingsThemeDark => 'Dark Mode';

  @override
  String get settingsPushNotifications => 'Push Notifications';

  @override
  String get settingsTerms => 'Terms of Service';

  @override
  String get settingsPrivacy => 'Privacy Policy';

  @override
  String get settingsAppVersion => 'Version';

  @override
  String get settingsDeleteAccount => 'Delete Account';

  @override
  String get settingsConfirmDeleteTitle => 'Delete Account?';

  @override
  String get settingsConfirmDeleteMessage =>
      'This action cannot be undone. All your data will be permanently removed.';

  @override
  String get settingsEnterPasswordFirst =>
      'Please enter your current password to confirm deletion.';

  @override
  String get settingsDelete => 'DELETE';

  @override
  String get settingsCancel => 'CANCEL';

  @override
  String get profileEditTitle => 'EDIT PROFILE';

  @override
  String get profileEditSubtitle =>
      'Update your information and profile details.';

  @override
  String get profileSave => 'SAVE CHANGES';

  @override
  String get profileUpdateSuccess => 'Profile updated successfully!';

  @override
  String get passwordChangeTitle => 'CHANGE PASSWORD';

  @override
  String get passwordCurrentLabel => 'Current Password';

  @override
  String get passwordCurrentHint => 'Enter current password';

  @override
  String get passwordUpdateSuccess => 'Password updated successfully!';

  @override
  String get errorUpdatingProfile => 'Error updating profile';

  @override
  String get errorUpdatingPassword => 'Error updating password';

  @override
  String get authFirstNameLabel => 'First Name';

  @override
  String get authFirstNameHint => 'Enter your first name';

  @override
  String get authLastNameLabel => 'Last Name';

  @override
  String get authLastNameHint => 'Enter your last name';

  @override
  String get authBirthDateLabel => 'Birth Date';

  @override
  String get authBirthDateHint => 'Select your birth date';

  @override
  String get profileFamilyAccount => 'Family Account';

  @override
  String get profileEnableFamilyAccount => 'Enable Family Account';

  @override
  String get profileFamilyAccountDescription =>
      'Manage your children\'s profiles and activities.';

  @override
  String get profileAddChild => 'Add Child';

  @override
  String get profileEditChild => 'Edit Child';

  @override
  String get profileNoChildren => 'No children profiles added.';

  @override
  String get profileChildName => 'Child Name';

  @override
  String get profileChildBirthDate => 'Child Birth Date';

  @override
  String get profileVerifyFamilyTitle => 'Verify Family Account';

  @override
  String profileVerifyFamilySubtitle(Object identifier) {
    return 'To enable family account, we need to verify your identity. Enter the code sent to your $identifier.';
  }

  @override
  String get profileFamilyEnabled => 'Family account enabled successfully!';

  @override
  String get profileFamilyNotEnabled =>
      'Enable family account to manage your children\'s profiles.';

  @override
  String get profileManageChildren => 'Manage Children';

  @override
  String get profileEdit => 'Edit';

  @override
  String get profileDelete => 'Delete';

  @override
  String get profileConfirmDeleteChild => 'Delete Child?';

  @override
  String profileConfirmDeleteChildMessage(String childName) {
    return 'Are you sure you want to remove $childName from your family account? This action cannot be undone.';
  }

  @override
  String get profileChildRemoved => 'Child profile removed successfully.';

  @override
  String get profileChildAdded => 'Child profile added successfully.';

  @override
  String get profileChildUpdated => 'Child profile updated successfully.';

  @override
  String get profileFirstName => 'First Name';

  @override
  String get profileFirstNameHint => 'Enter child\'s first name';

  @override
  String get profileLastName => 'Last Name';

  @override
  String get profileLastNameHint => 'Enter child\'s last name';

  @override
  String get profileGender => 'Gender';

  @override
  String get profileMale => 'Boy';

  @override
  String get profileFemale => 'Girl';

  @override
  String get profileGenderNotSpecified => 'Not specified';

  @override
  String get profileBirthDate => 'Date of Birth';

  @override
  String get profileSelectDate => 'Select date of birth';

  @override
  String get profileNoChildrenDescription =>
      'Start by adding your child\'s profile to manage their activities.';

  @override
  String get authVerificationMethodTitle => 'Security Verification';

  @override
  String get authVerificationMethodSubtitle =>
      'Choose a method to receive your verification code.';

  @override
  String get profileNoVerifiedOtpMethod =>
      'You need at least one verified contact method (email or phone) before enabling a family account.';

  @override
  String get authEmailMethod => 'Email Address';

  @override
  String get authPhoneMethod => 'Phone Number';

  @override
  String get authMethodAccessInstruction =>
      'Make sure you have access to the selected method.';

  @override
  String get authFamilyOnboardingTitle => 'Family Members';

  @override
  String get authFamilyOnboardingSubtitle =>
      'Add details for your family members (Optional).';

  @override
  String get authAddMember => 'Add Member';

  @override
  String get authAddedMembers => 'Added Members';

  @override
  String get authDoItLater => 'Do it later';

  @override
  String get authAccountOverviewTitle => 'Account Overview';

  @override
  String get authAccountOverviewSubtitle =>
      'Review your details and upload a profile picture.';

  @override
  String get authProfilePictureRecommendation =>
      'We recommend uploading a clear photo of yourself for recognition at the arena entrance.';

  @override
  String get authConfirmContinue => 'Confirm & Continue';

  @override
  String get authEditInformation => 'Edit Information';

  @override
  String get authPinSetupTitle => 'Secure PIN';

  @override
  String get authPinSetupSubtitle =>
      'Create a 4-digit PIN for your first gym entry.';

  @override
  String get authPinSetupInstruction =>
      'This PIN will be used at the gym kiosks.';

  @override
  String get authCompleteRegistration => 'Complete Registration';

  @override
  String get authSetupRequiredTitle => 'Account Setup Required';

  @override
  String get authSetupRequiredMessage =>
      'Account setup is not completed. Please complete your profile to unlock your account.';

  @override
  String get authCompleteSetup => 'Complete Setup';

  @override
  String get languageSelectionTitle => 'Welcome to Bourgo Arena';

  @override
  String get languageSelectionSubtitle =>
      'Please select your preferred language to continue';

  @override
  String get languageLabel => 'Select Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get profileStandardTier => 'Standard';

  @override
  String get authInvalidVerificationCode => 'Invalid verification code';

  @override
  String get searchHint => 'Search activities, courses, settings...';

  @override
  String get searchRecentTitle => 'Global Search';

  @override
  String get searchRecentSubtitle =>
      'Find activities, courses, or settings across the app.';

  @override
  String searchNoResultsTitle(String query) {
    return 'No results for \"$query\"';
  }

  @override
  String get searchNoResultsSubtitle =>
      'Try different keywords or check spelling.';

  @override
  String get subscriptionSelectPlanTitle => 'Select a Plan';

  @override
  String get subscriptionPlanBasic => 'Basic';

  @override
  String get subscriptionPlanPremium => 'Premium';

  @override
  String get subscriptionConfirmPlan => 'CONFIRM PLAN';

  @override
  String subscriptionPricePerMonth(String price) {
    return '$price TND / month';
  }

  @override
  String get profileOtpCodeLabel => 'OTP Code';

  @override
  String get profileOtpCodeHint => '000000';

  @override
  String get bookingPointsToEarned => 'Points to be earned';

  @override
  String get courseFull => 'FULL';

  @override
  String courseRemaining(String remaining) {
    return '$remaining LEFT';
  }

  @override
  String get loyaltyDashboardTitle => 'Loyalty Program';

  @override
  String get loyaltyTotalPoints => 'Total Points';

  @override
  String get loyaltyGoldMember => 'Gold Member';

  @override
  String loyaltyPointsToPlatinum(String points) {
    return '$points points until Platinum Tier';
  }

  @override
  String get profileLogoutTitle => 'Sign Out?';

  @override
  String get profileLogoutMessage =>
      'Are you sure you want to sign out? You\'ll need to log in again to access your account.';

  @override
  String get profileLogoutConfirm => 'SIGN OUT';

  @override
  String get profileLogoutSuccess => 'You have been signed out successfully';

  @override
  String get languageFrench => 'Français';

  @override
  String get authGenderLabel => 'Gender';

  @override
  String get authGenderHint => 'Select gender';

  @override
  String get legalLastUpdated => 'Last Updated: May 2026';

  @override
  String get privacyPolicySection1Title => '1. Information Collection';

  @override
  String get privacyPolicySection1Content =>
      'We collect personal information that you provide to us, such as your name, email address, phone number, and payment information when you register or use our services.';

  @override
  String get privacyPolicySection2Title => '2. Use of Information';

  @override
  String get privacyPolicySection2Content =>
      'Your information is used to provide and improve our services, process payments, send notifications about your bookings, and communicate with you about updates or offers.';

  @override
  String get privacyPolicySection3Title => '3. Data Security';

  @override
  String get privacyPolicySection3Content =>
      'We implement industry-standard security measures to protect your personal data. However, no method of transmission over the internet is 100% secure.';

  @override
  String get privacyPolicySection4Title => '4. Third-Party Services';

  @override
  String get privacyPolicySection4Content =>
      'We may use third-party service providers to facilitate our services, such as payment processors. These third parties have access to your information only to perform specific tasks on our behalf.';

  @override
  String get privacyPolicySection5Title => '5. Your Rights';

  @override
  String get privacyPolicySection5Content =>
      'You have the right to access, update, or delete your personal information at any time through the app settings or by contacting our support team.';

  @override
  String get privacyPolicySection6Title => '6. Cookies and Tracking';

  @override
  String get privacyPolicySection6Content =>
      'We use cookies and similar tracking technologies to track activity on our service and hold certain information to improve your experience.';

  @override
  String get termsSection1Title => '1. Acceptance of Terms';

  @override
  String get termsSection1Content =>
      'By accessing or using Bourgo Arena services, you agree to be bound by these terms. If you do not agree, please do not use the application.';

  @override
  String get termsSection2Title => '2. Description of Service';

  @override
  String get termsSection2Content =>
      'Bourgo Arena provides a platform for booking sports facilities, managing gym memberships, and participating in scheduled fitness classes in Djerba, Tunisia.';

  @override
  String get termsSection3Title => '3. User Responsibilities';

  @override
  String get termsSection3Content =>
      'Users are responsible for maintaining the confidentiality of their accounts and for all activities that occur under their credentials. You agree to follow gym rules and respect other members.';

  @override
  String get termsSection4Title => '4. Bookings and Payments';

  @override
  String get termsSection4Content =>
      'All bookings are subject to availability. Payments made through the app are processed securely. Cancellations must be made according to our cancellation policy to be eligible for refunds.';

  @override
  String get termsSection5Title => '5. Limitation of Liability';

  @override
  String get termsSection5Content =>
      'Bourgo Arena is not liable for any personal injury or property damage sustained while using the facilities, except where caused by our gross negligence.';

  @override
  String get termsSection6Title => '6. Changes to Terms';

  @override
  String get termsSection6Content =>
      'We reserve the right to modify these terms at any time. Your continued use of the app after such changes constitutes acceptance of the new terms.';

  @override
  String get errorNotFoundTitle => 'PAGE NOT FOUND';

  @override
  String get errorNotFoundSubtitle =>
      'Oops! The page you\'re looking for doesn\'t exist or has been moved.';

  @override
  String get errorNotFoundAction => 'GO BACK HOME';

  @override
  String get profileDisableFamilyTitle => 'Disable Family Account?';

  @override
  String get profileDisableFamilyContent =>
      'This will hide all children profiles and features. Are you sure you want to continue?';

  @override
  String get profileDisableConfirm => 'DISABLE';

  @override
  String get commonCancel => 'CANCEL';

  @override
  String get commonContinue => 'CONTINUE';

  @override
  String get authVerifyAdditionalMethodTitle => 'Complete Your Verification';

  @override
  String authVerifyAdditionalMethodMessage(Object method) {
    return 'To ensure account security, please verify your $method.';
  }

  @override
  String get authVerifyNow => 'VERIFY NOW';

  @override
  String get authSkipForNow => 'SKIP FOR NOW';

  @override
  String get authEmailVerificationPending => 'Email verification pending';

  @override
  String get authPhoneVerificationPending => 'Phone verification pending';

  @override
  String get authBothMethodsVerified => 'Both email and phone are verified';

  @override
  String get authOneMethodVerified => 'One method verified, one pending';

  @override
  String get authVerifyPhoneTitle => 'Verify Phone Number';

  @override
  String authVerifyPhoneSubtitle(Object phone) {
    return 'We\'ll send a 6-digit code to your phone $phone.';
  }

  @override
  String get authVerifyEmailTitle => 'Verify Email Address';

  @override
  String authVerifyEmailSubtitle(Object email) {
    return 'We\'ll send a 6-digit code to your email $email.';
  }

  @override
  String get authVerificationCompleteTitle => 'Verification Complete';

  @override
  String get authVerificationCompleteMessage =>
      'All verification methods have been successfully verified. Let\'s continue with your profile setup.';

  @override
  String get authDontShowAgain => 'Don\'t show again';

  @override
  String get authSkipForever => 'SKIP FOREVER';

  @override
  String get authSkipForeverMessage =>
      'We recommend verifying both methods for maximum security. You can always do this later in settings.';

  @override
  String get loyaltyRecentTransactions => 'Recent Transactions';

  @override
  String get loyaltyNoTransactions => 'No Transactions Yet';

  @override
  String get loyaltyNoTransactionsSubtitle =>
      'You haven\'t earned or spent any points yet. Start booking courses to earn points!';

  @override
  String get themeSelectionTitle => 'Choose Your Style';

  @override
  String get themeSelectionSubtitle =>
      'Select a display mode for your application';

  @override
  String get activitiesTitle => 'ACTIVITIES';

  @override
  String get coursesTitle => 'COURSES';

  @override
  String get coursesSubscriptionRequired =>
      'Certain courses require a subscription to book sessions.';

  @override
  String get coursesViewOffers => 'VIEW OFFERS';

  @override
  String get childSelectorTitle => 'WHO IS THIS FOR?';

  @override
  String get childSelectorSelfDesc => 'Subscribe for yourself';

  @override
  String get childSelectorNoChildrenTitle => 'No children found';

  @override
  String get childSelectorNoChildrenDesc =>
      'You currently have no children added.';

  @override
  String get otpVerifyTitlePrefix => 'VERIFY';

  @override
  String get otpSentToText => 'We\'ve sent a code to\n';

  @override
  String get otpPasteClipboard => 'PASTE FROM CLIPBOARD';

  @override
  String get otpErrorIncomplete => 'Please enter all 6 digits';

  @override
  String get otpErrorFailed => 'Verification failed';

  @override
  String get paymentErrorLaunch => 'Could not open payment page.';

  @override
  String get paymentTitle => 'Payment';

  @override
  String get paymentPreparing => 'Preparing payment...';

  @override
  String get paymentVerifying => 'Verifying payment...';

  @override
  String get paymentSuccessTitle => 'Payment Successful!';

  @override
  String get paymentSuccessDesc => 'Your booking is confirmed.';

  @override
  String get paymentBackHome => 'Back to Home';

  @override
  String get paymentFailedTitle => 'Payment Failed';

  @override
  String get paymentTryAgain => 'Try Again';

  @override
  String get reservationsTitle => 'MY RESERVATIONS';

  @override
  String get reservationsUpcomingTab => 'UPCOMING';

  @override
  String get reservationsHistoryTab => 'HISTORY';

  @override
  String get reservationsEmptyUpcomingTitle => 'NO UPCOMING RESERVATIONS';

  @override
  String get reservationsEmptyUpcomingDesc =>
      'You don\'t have any upcoming reservations yet.';

  @override
  String get reservationsEmptyHistoryTitle => 'EMPTY HISTORY';

  @override
  String get reservationsEmptyHistoryDesc =>
      'You don\'t have any past reservations yet.';

  @override
  String get errorLoadingFailed => 'Loading failed';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionCancel => 'CANCEL';

  @override
  String get actionVerify => 'VERIFY';

  @override
  String get actionPayNow => 'PAY NOW';

  @override
  String get paymentErrorGeneric => 'An error occurred.';

  @override
  String get paymentPointsTitle => 'PAY WITH POINTS';

  @override
  String get paymentPointsDesc =>
      'You are about to pay for your booking using your loyalty points. This action cannot be undone.';

  @override
  String get paymentErrorMissingId =>
      'Missing reservation ID for loyalty payment.';

  @override
  String get paymentErrorInvalidId => 'Invalid reservation ID format.';

  @override
  String get paymentErrorNoUrl =>
      'No payment URL received from server. Please retry.';

  @override
  String get paymentErrorUnconfirmed =>
      'Payment not yet confirmed. You can check your bookings.';

  @override
  String get paymentCreatingReservation => 'Creating reservation...';

  @override
  String get paymentOpeningGateway => 'Opening payment gateway...';

  @override
  String get paymentViewBooking => 'VIEW MY BOOKING';

  @override
  String get paymentDepositRequired => '10% Deposit Required';

  @override
  String get paymentMethodCardDesc => 'Bank Cards, E-Dinar, Wallets';

  @override
  String get paymentMethodPointsDesc => 'Use your accumulated loyalty points';

  @override
  String get serviceDetailPlans => 'Plans';

  @override
  String get serviceDetailCourses => 'Courses';

  @override
  String get serviceDetailEvents => 'Events';

  @override
  String get serviceDetailActivities => 'Activities';

  @override
  String get serviceDetailErrorMsg => 'Something went wrong';

  @override
  String get serviceDetailRetry => 'Retry';

  @override
  String get serviceDetailActive => 'Active';

  @override
  String get serviceDetailAnnual => 'Annual';

  @override
  String get serviceDetailYears => 'Years';

  @override
  String get serviceDetailMonthly => 'Monthly';

  @override
  String get serviceDetailMonths => 'Months';

  @override
  String get serviceDetailDays => 'Days';

  @override
  String get serviceDetailAllCourses => 'All Courses';

  @override
  String get serviceDetailEventLabel => 'Event';

  @override
  String get servicesTitle => 'Services';

  @override
  String get servicesSearchHint => 'Search services...';

  @override
  String get servicesFilterAll => 'All';

  @override
  String get servicesFilterPlans => 'Plans';

  @override
  String get servicesFilterCourses => 'Courses';

  @override
  String get servicesFilterEvents => 'Events';

  @override
  String get servicesNoMatching => 'No matching services';

  @override
  String get servicesNoAvailable => 'No services available';

  @override
  String get servicesAdjustSearch => 'Try adjusting your search or filters.';

  @override
  String get servicesCheckBack => 'Check back soon for new services.';

  @override
  String get notifGlobalTitle => 'Global Notifications';

  @override
  String get notifEnablePush => 'Enable Push Notifications';

  @override
  String get notifEnablePushSub => 'Master toggle for all push notifications';

  @override
  String get notifPlanningTitle => 'Planning & Courses';

  @override
  String get notifReservations => 'Reservations & Planning';

  @override
  String get notifReservationsSub =>
      'Booking confirmations, reminders, and cancellations';

  @override
  String get notifCourses => 'Courses';

  @override
  String get notifCoursesSub =>
      'Updates from your enrolled courses and instructors';

  @override
  String get notifAccountTitle => 'Account & Payments';

  @override
  String get notifSubscriptions => 'Subscriptions';

  @override
  String get notifSubscriptionsSub => 'Renewal notices and payment issues';

  @override
  String get notifSecurity => 'Security Warnings & Updates';

  @override
  String get notifSecuritySub =>
      'Crucial account security and activity updates';

  @override
  String get notifCommunityTitle => 'Community & Offers';

  @override
  String get notifFamily => 'Family Activity';

  @override
  String get notifFamilySub => 'Child account activities and approvals';

  @override
  String get notifLoyalty => 'Loyalty & Points';

  @override
  String get notifLoyaltySub => 'Rewards earned and tier upgrades';

  @override
  String get notifPromo => 'Promotions & Offers';

  @override
  String get notifPromoSub => 'Receive updates on new deals and events';

  @override
  String get paymentPayWithPointsTitle => 'PAY WITH POINTS';

  @override
  String paymentPayWithPointsWarning(String price) {
    return 'You are about to pay $price TND using your loyalty points. This action cannot be undone.';
  }

  @override
  String get paymentPayNow => 'PAY NOW';

  @override
  String get paymentErrorCannotOpen => 'Could not open payment page.';

  @override
  String get paymentFailedRetry => 'Payment failed. Please try again.';

  @override
  String get paymentMethodTitle => 'PAYMENT METHOD';

  @override
  String get paymentLoadingCreatingSub => 'Creating subscription...';

  @override
  String get paymentLoadingPreparing => 'Preparing payment...';

  @override
  String get paymentLoadingLoyalty => 'Processing loyalty payment...';

  @override
  String get paymentLoadingVerifying => 'Verifying payment...';

  @override
  String paymentSuccessChildDesc(String planName) {
    return 'Subscription to $planName is now active for your child.';
  }

  @override
  String get paymentBackToHome => 'BACK TO HOME';

  @override
  String get paymentUnknownError => 'An unknown error occurred.';

  @override
  String get paymentTotalAmount => 'TOTAL AMOUNT';

  @override
  String paymentForPlan(String planName) {
    return 'For $planName';
  }

  @override
  String get paymentSelectMethod => 'SELECT PAYMENT METHOD';

  @override
  String get paymentMethodKonnectTitle => 'Pay with Konnect';

  @override
  String get paymentMethodKonnectSubtitle => 'Bank Cards, E-Dinar, Wallets';

  @override
  String get paymentOr => 'OR';

  @override
  String get paymentMethodLoyaltyTitle => 'Pay with Loyalty Balance';

  @override
  String get paymentMethodLoyaltySubtitle => 'Use your accumulated points';

  @override
  String get paymentSecurePaymentTitle => 'SECURE PAYMENT';

  @override
  String courseDetailBookedSession(String title, String date, String time) {
    return 'Reserved $title on $date at $time';
  }

  @override
  String get subscriptionRequiredTitle => 'SUBSCRIPTION REQUIRED';

  @override
  String get subscriptionRequiredBookMessage =>
      'You need an active subscription to book sessions. Subscribe to a plan and try again.';

  @override
  String get subscriptionRequiredSignInMessage =>
      'Sign in and subscribe to a plan to book sessions.';

  @override
  String get closeButton => 'CLOSE';

  @override
  String get viewPlansButton => 'VIEW PLANS';

  @override
  String get signInButton => 'SIGN IN';

  @override
  String get monthJanuary => 'January';

  @override
  String get monthFebruary => 'February';

  @override
  String get monthMarch => 'March';

  @override
  String get monthApril => 'April';

  @override
  String get monthMay => 'May';

  @override
  String get monthJune => 'June';

  @override
  String get monthJuly => 'July';

  @override
  String get monthAugust => 'August';

  @override
  String get monthSeptember => 'September';

  @override
  String get monthOctober => 'October';

  @override
  String get monthNovember => 'November';

  @override
  String get monthDecember => 'December';

  @override
  String get reserveAction => 'RESERVE';

  @override
  String get daySunday => 'Sunday';

  @override
  String get dayMonday => 'Monday';

  @override
  String get dayTuesday => 'Tuesday';

  @override
  String get dayWednesday => 'Wednesday';

  @override
  String get dayThursday => 'Thursday';

  @override
  String get dayFriday => 'Friday';

  @override
  String get daySaturday => 'Saturday';

  @override
  String get courseDefaultTitle => 'COURSE';

  @override
  String get upcomingSessionsTitle => 'UPCOMING SESSIONS';

  @override
  String get noUpcomingSessionsMessage => 'No upcoming sessions this week';

  @override
  String get subscriptionRequiredViewBookMessage =>
      'You need an active subscription to view and book sessions for this course.';

  @override
  String get subscriptionRequiredSignInViewBookMessage =>
      'Sign in and subscribe to a plan to view and book sessions.';

  @override
  String get statusBooked => 'BOOKED';

  @override
  String get statusFull => 'FULL';

  @override
  String remainingPlaces(String count) {
    return '$count PLACES';
  }

  @override
  String get viewDetailsLabel => 'VIEW DETAILS';

  @override
  String get signInRequiredTitle => 'Sign In Required';

  @override
  String get signInRequiredMessage =>
      'You need to be logged in to view and book courses. Join us to start your fitness journey!';

  @override
  String get signInRegisterButton => 'Sign In / Register';

  @override
  String get unlockPlanningTitle => 'Unlock Planning';

  @override
  String get unlockPlanningMessage =>
      'An active subscription is required to view course schedules and book classes. Join us and elevate your fitness journey!';

  @override
  String get viewPlansLabel => 'View Plans';

  @override
  String get planningErrorTitle => 'PLANNING ERROR';

  @override
  String get planningErrorMessage =>
      'Unable to fetch the course schedule. Please check your connection.';

  @override
  String get retryAction => 'Retry';

  @override
  String get planningSignInTitle => 'SIGN IN';

  @override
  String get planningSignInMessage =>
      'Sign in to access your course schedule and book sessions.';

  @override
  String get planningNoSessionsTitle => 'NO SESSIONS';

  @override
  String get planningNoSessionsSubscriptionMessage =>
      'No sessions available with your current subscription. Upgrade to a higher subscription to access more courses.';

  @override
  String get planningNoSessionsWeekMessage =>
      'No upcoming sessions this week. Check back later to see the schedule.';

  @override
  String get meLabel => 'Me';

  @override
  String meMemberName(String name) {
    return '$name (Me)';
  }

  @override
  String get browseFilterAll => 'All';

  @override
  String get browseTabCourses => 'COURSES';

  @override
  String get browseTabActivities => 'ACTIVITIES';

  @override
  String get browseTabEvents => 'EVENTS';

  @override
  String get browseErrorTitle => 'ERROR';

  @override
  String get browseErrorRetry => 'RETRY';

  @override
  String get browseEventFallback => 'EVENT';

  @override
  String get browseUnknownStatus => 'Unknown';

  @override
  String get profileSubscriptionSubtitle =>
      'Manage your plan and premium access';

  @override
  String get profileNotificationsSubtitle =>
      'Manage your alerts and class reminders';

  @override
  String get profileSettingsSubtitle => 'Personal information and security';

  @override
  String get editProfilePhotoTitle => 'PROFILE PHOTO';

  @override
  String get editProfileTakePhoto => 'TAKE A PHOTO';

  @override
  String get editProfileChoosePhoto => 'CHOOSE A PHOTO';

  @override
  String get editProfileDeletePhoto => 'DELETE PHOTO';

  @override
  String get editProfilePhotoUpdated => 'Profile photo updated';

  @override
  String get editProfilePhotoFailed => 'Upload failed';

  @override
  String get editProfileDeletePhotoConfirm =>
      'Are you sure you want to delete your profile photo?';

  @override
  String get commonDelete => 'DELETE';

  @override
  String get editProfilePhotoDeleted => 'Profile photo deleted';

  @override
  String get editProfilePhotoDeleteFailed => 'Failed to delete';

  @override
  String get editProfileOtpSendFailed => 'Failed to send OTP to';

  @override
  String get editProfileVerifiedUpdated => 'verified and updated successfully!';

  @override
  String get editProfileUpdateFailed => 'Failed to update';

  @override
  String get editProfileTabPersonal => 'PERSONAL';

  @override
  String get editProfileTabSecurity => 'SECURITY';

  @override
  String get editProfileGender => 'GENDER';

  @override
  String get editProfileGenderHint => 'Select Gender';

  @override
  String get editProfileGenderMale => 'Male';

  @override
  String get editProfileGenderFemale => 'Female';

  @override
  String get commonVerify => 'VERIFY';

  @override
  String get editProfileSecurityNotice =>
      'Changes to your email or phone number require OTP verification. Enter a new value and click VERIFY.';

  @override
  String get editProfileEmailHint => 'Enter your email';

  @override
  String get editProfilePhoneHint => 'Enter your phone number';

  @override
  String get planDetailChildOnlyPlan => 'Child-Only Plan';

  @override
  String get planDetailChildOnlyDesc =>
      'This plan is designed for children only. Select a child to purchase this plan for them.';

  @override
  String get planDetailSelectChild => 'SELECT A CHILD';

  @override
  String get planDetailChildAdded =>
      'Child added. Please select them to continue.';

  @override
  String get planDetailTitle => 'PLAN DETAILS';

  @override
  String get planDetailIncludes => 'INCLUDES';

  @override
  String get planDetailAccessAllCourses => 'Access to ALL courses';

  @override
  String get planDetailSubscribeFor => 'SUBSCRIBE FOR';

  @override
  String get planDetailMyself => 'Myself';

  @override
  String get planDetailChild => 'Child';

  @override
  String get planDetailActivePlan => 'ACTIVE PLAN';

  @override
  String get planDetailSubscribeBtn => 'SUBSCRIBE';

  @override
  String get planDetailErrorSomethingWentWrong => 'Something went wrong';

  @override
  String get planDetailRetryBtn => 'RETRY';

  @override
  String get planDetailNotFound => 'Plan not found';

  @override
  String get planDetailArchived =>
      'This plan may have been archived or removed.';

  @override
  String get commonGoBack => 'GO BACK';

  @override
  String get eventsBracketRound => 'Round';

  @override
  String get eventsBracketSemiFinals => 'Semi-Finals';

  @override
  String get eventsBracketTBD => 'TBD';

  @override
  String get eventsBracketTitle => 'Tournament Bracket';

  @override
  String get eventsBracketWalkover => 'Walkover';

  @override
  String get eventsDetailCheckedInStatus => 'Checked In';

  @override
  String get eventsDetailCheckInAction => 'Check In';

  @override
  String get eventsDetailCheckInRequired => 'Check-in required';

  @override
  String get eventsDetailCheckInSuccess => 'Successfully checked in';

  @override
  String get eventsDetailDateTBD => 'Date TBD';

  @override
  String get eventsDetailErrorTitle => 'Error';

  @override
  String get eventsDetailEventFallback => 'Event';

  @override
  String get eventsDetailFormat => 'Format';

  @override
  String get eventsDetailNotFound => 'Event not found';

  @override
  String get eventsDetailParticipantsText => 'Participants';

  @override
  String get eventsDetailRegisterAction => 'Register';

  @override
  String get eventsDetailRegisterBy => 'Register by';

  @override
  String get eventsDetailRegisteredStatus => 'Registered';

  @override
  String get eventsDetailRegisterSuccess => 'Successfully registered';

  @override
  String get eventsDetailRegisterTitle => 'Register for Event';

  @override
  String get eventsDetailRegistrationClosed => 'Registration Closed';

  @override
  String get eventsDetailRetryButton => 'Retry';

  @override
  String get eventsDetailTBD => 'TBD';

  @override
  String get eventsDetailThisEvent => 'this event';

  @override
  String get eventsDetailViewBracketButton => 'View Bracket';

  @override
  String get eventsDetailWaitlistSuccess => 'Added to waitlist';

  @override
  String get eventsDetailWithdrawPromptPrefix =>
      'Are you sure you want to withdraw from';

  @override
  String get eventsDetailWithdrawSuccess => 'Successfully withdrawn';

  @override
  String get eventsDetailWithdrawTitle => 'Withdraw';

  @override
  String get eventsScreenCheckBackSoon =>
      'Check back soon for upcoming tournaments';

  @override
  String get eventsScreenEventFallback => 'Event';

  @override
  String get eventsScreenNoTournaments => 'No Tournaments Available';

  @override
  String get eventsScreenRetryButton => 'Retry';

  @override
  String get eventsScreenTitle => 'Tournaments';

  @override
  String get myEventsScreenNoEvents => 'No Events Found';

  @override
  String get myEventsScreenRetryButton => 'Retry';

  @override
  String get myEventsScreenTitle => 'My Events';

  @override
  String get familyChildBookingsEmptyMessage => 'No bookings found.';

  @override
  String get familyChildBookingsEmptyTitle => 'No Bookings';

  @override
  String get familyChildBookingsTitle => 'Bookings';

  @override
  String get familyChildCompletedAtPrefix => 'Completed at:';

  @override
  String get familyChildCompletedEmptyTitle => 'No Completed Activities';

  @override
  String get familyChildCompletedTitle => 'Completed';

  @override
  String get familyChildProfileDaysRemainingText => 'days remaining';

  @override
  String get familyChildProfileEnd => 'End:';

  @override
  String get familyChildProfileErrorFallback => 'An error occurred';

  @override
  String get familyChildProfileRetryButton => 'Retry';

  @override
  String get familyChildProfileScheduleButton => 'Schedule';

  @override
  String get familyChildProfileStart => 'Start:';

  @override
  String get familyChildReservationsTitle => 'Reservations';

  @override
  String get familyChildScheduleEmptyMessage =>
      'No courses or activities in this date range.';

  @override
  String get familyChildScheduleEmptyTitle => 'No events scheduled';

  @override
  String get familyChildScheduleFrom => 'FROM';

  @override
  String get familyChildScheduleTitle => 'SCHEDULE';

  @override
  String get familyChildScheduleTo => 'TO';

  @override
  String get familyChildScheduleCompletedStatus => 'Completed';

  @override
  String get familyChildSessionsBookCancel => 'Cancel';

  @override
  String get familyChildSessionsBookDate => 'Date:';

  @override
  String get familyChildSessionsBookDay => 'Day:';

  @override
  String get familyChildSessionsBookFull => 'Session is full';

  @override
  String get familyChildSessionsBookSpots => 'Spots:';

  @override
  String get familyChildSessionsBookTime => 'Time:';

  @override
  String get familyChildSessionsBookTitle => 'Book Session';

  @override
  String get familyChildSessionsEmptyTitle => 'No sessions available';

  @override
  String get familyChildSessionsTitle => 'AVAILABLE SESSIONS';

  @override
  String get familyChildSessionsBookSuccess => 'Successfully booked!';

  @override
  String get familyChildSessionsBookFailure => 'Failed to book';

  @override
  String get familyChildSessionsBookConfirm => 'Confirm Booking';

  @override
  String get familyChildSessionsStatusBooked => 'Booked';

  @override
  String get familyChildSessionsStatusFull => 'FULL';

  @override
  String get familyChildSessionsBookTooltip => 'Book session';

  @override
  String get familyChildSubscriptionsDaysRemaining => 'days remaining';

  @override
  String get familyChildSubscriptionsEnd => 'End:';

  @override
  String get familyChildSubscriptionsStart => 'Start:';

  @override
  String get familyChildSubscriptionsTitle => 'SUBSCRIPTIONS';

  @override
  String get familyChildSubscriptionsBuyNew => 'BUY NEW SUBSCRIPTION';

  @override
  String get familyChildSubscriptionsEmptyTitle => 'No subscriptions';

  @override
  String get familyChildSubscriptionsEmptyMessage =>
      'Buy a subscription to get started.';

  @override
  String get homeAvailable => 'available';

  @override
  String get homeCoursesTitle => 'COURSES';

  @override
  String get homeEventsTitle => 'TOURNAMENTS & EVENTS';

  @override
  String get homeExploreButton => 'EXPLORE';

  @override
  String get homeGlobalSearchTooltip => 'Global Search';

  @override
  String get homeNo => 'No';

  @override
  String get homeRetryButton => 'RETRY';

  @override
  String get homeSeeAllButton => 'SEE ALL';

  @override
  String get homeServiceCourses => 'courses';

  @override
  String get homeServiceEvents => 'events';

  @override
  String get homeServicePlans => 'plans';

  @override
  String get homeServicesEmpty => 'No services available';

  @override
  String get homeServicesTitle => 'OUR SERVICES';

  @override
  String get homeActivityExploreButton => 'EXPLORE';

  @override
  String get loyaltyLoadFailedMessage => 'Unable to load your points.';

  @override
  String get loyaltyLoadFailedTitle => 'Load failed';

  @override
  String get loyaltyMaxTierReached => 'Maximum level reached';

  @override
  String get loyaltyMyPointsTitle => 'MY POINTS';

  @override
  String get loyaltyNextTier => 'Next tier';

  @override
  String get loyaltyNoTransactionMessage =>
      'Your points transactions will appear here.';

  @override
  String get loyaltyNoTransactionTitle => 'No transaction';

  @override
  String get loyaltyPointsBalance => 'POINTS BALANCE';

  @override
  String get loyaltyPointsHistoryTitle => 'POINTS HISTORY';

  @override
  String get loyaltyPts => 'pts';

  @override
  String get loyaltyRetryButton => 'RETRY';

  @override
  String get loyaltySourceDailyCheckin => 'Daily Check-in';

  @override
  String get loyaltySourceReferral => 'Referral';

  @override
  String get loyaltySourceSubscriptionRenewal => 'Subscription Renewal';

  @override
  String get loyaltySourceReservationCompleted => 'Reservation Completed';

  @override
  String get loyaltySourceWelcomeBonus => 'Welcome Bonus';

  @override
  String get loyaltySourceTransaction => 'Transaction';

  @override
  String get notificationFilterAll => 'ALL';

  @override
  String get notificationFilterUnread => 'UNREAD';

  @override
  String get notificationFilterReservations => 'RESERVATIONS';

  @override
  String get notificationFilterSubscriptions => 'SUBSCRIPTIONS';

  @override
  String get notificationFilterLoyalty => 'LOYALTY';

  @override
  String get notificationFilterOffers => 'OFFERS';

  @override
  String get notificationFilterFamily => 'FAMILY';

  @override
  String get notificationCaughtUpMessage => 'YOU ARE CAUGHT UP';

  @override
  String get notificationEmptyFilterMessage =>
      'No notifications match this filter.';

  @override
  String get notificationEmptyFilterTitle => 'No results';

  @override
  String get notificationEmptyMessage =>
      'You have no notifications at the moment.';

  @override
  String get notificationEmptyTitle => 'No notifications';

  @override
  String get notificationLoadFailedTitle => 'Load failed';

  @override
  String get notificationMarkAllReadTooltip => 'Mark all as read';

  @override
  String get notificationRetryButton => 'Retry';

  @override
  String get notificationScreenTitle => 'NOTIFICATIONS';

  @override
  String get familyChildProfileActiveSubscription => 'Active Subscription';

  @override
  String get familyChildProfileSubscriptionsButton => 'Subscriptions';

  @override
  String get familyChildProfileBookingsButton => 'Bookings';

  @override
  String get familyChildProfileSessionsButton => 'Sessions';

  @override
  String get familyChildProfileReservationsButton => 'Reservations';

  @override
  String get familyChildProfileCompletedButton => 'Completed';

  @override
  String get familyChildBookingCompletedSuccess => 'Marked as completed';

  @override
  String get familyChildBookingCompletedFailure => 'Failed to complete';

  @override
  String get familyChildBookingsCompletedStatus => 'Completed';

  @override
  String get familyChildBookingsMarkCompletedTooltip => 'Mark as completed';

  @override
  String get familyChildReservationsEmptyTitle => 'No reservations';

  @override
  String get familyChildReservationsEmptyMessage => 'You have no reservations.';

  @override
  String get familyChildReservationsShowQrTooltip => 'Show QR code';

  @override
  String get familyChildReservationsCloseButton => 'Close';

  @override
  String get familyChildCompletedEmptyMessage => 'No completed items.';

  @override
  String get familyChildCompletedStatus => 'Completed';

  @override
  String get eventsScreenWaitlistSuccess => 'Added to waitlist';

  @override
  String get eventsScreenRegisterSuccess => 'Successfully registered';

  @override
  String get eventsScreenViewDetailsButton => 'View details';

  @override
  String get eventsScreenRegisterButton => 'Register';

  @override
  String get eventsBracketRetryButton => 'Retry';

  @override
  String get eventsBracketNotAvailable => 'Bracket not available';

  @override
  String get eventsBracketFinal => 'Final';

  @override
  String get eventsBracketQuarterFinals => 'Quarter-Finals';

  @override
  String get eventsBracketCompleted => 'Completed';

  @override
  String get myEventsStatusRegistered => 'REGISTERED';

  @override
  String get myEventsStatusApproved => 'APPROVED';

  @override
  String get myEventsStatusPending => 'PENDING';

  @override
  String get myEventsStatusWithdrawn => 'WITHDRAWN';

  @override
  String get myEventsStatusWaitlisted => 'WAITLISTED';

  @override
  String get myEventsEventUpcoming => 'UPCOMING';

  @override
  String get myEventsEventInProgress => 'IN PROGRESS';

  @override
  String get myEventsEventCompleted => 'COMPLETED';

  @override
  String get paymentExternalTitle => 'Secure Gateway Opened';

  @override
  String get paymentExternalDesc =>
      'We have opened the payment gateway in your browser. Please complete the transaction there.';

  @override
  String get paymentOpenAgain => 'REOPEN PAYMENT PAGE';

  @override
  String get paymentDoneConfirm => 'I HAVE COMPLETED THE PAYMENT';

  @override
  String get paymentCancel => 'CANCEL';

  @override
  String get accountSetupSessionExpired =>
      'Your session needs to be refreshed. Please log in again.';

  @override
  String get accountSetupIncompleteOnboarding =>
      'Please complete all required onboarding fields before continuing.';

  @override
  String get subscriptionScreenTitle => 'MY SUBSCRIPTION';

  @override
  String get subscriptionManagementPageTitle => 'EXPLORE PLANS';

  @override
  String get subscriptionManagementSearchHint => 'Search plans or services...';

  @override
  String get planCardSubscribeButton => 'Subscribe';

  @override
  String get homeCarouselEmpty => 'Nothing here yet';

  @override
  String get subscriptionCardStartLabel => 'START';

  @override
  String get subscriptionCardEndLabel => 'END';

  @override
  String get offlineTitle => 'No Connection';

  @override
  String get offlineSubtitle =>
      'You are currently offline. Please check your internet connection to continue.';

  @override
  String get offlineRetryButton => 'Try Again';
}
