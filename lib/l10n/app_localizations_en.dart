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
  String get bookingViewTicket => 'VIEW TICKET';

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
}
