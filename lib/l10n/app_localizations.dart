import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In fr, this message translates to:
  /// **'Bourgo Arena'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In fr, this message translates to:
  /// **'Le QG du Sport à Djerba'**
  String get tagline;

  /// No description provided for @onboardingTitle.
  ///
  /// In fr, this message translates to:
  /// **'REPOUSSEZ VOS LIMITES'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Découvrez le centre de performance sportive ultime au cœur de Djerba.'**
  String get onboardingSubtitle;

  /// No description provided for @commonRetry.
  ///
  /// In fr, this message translates to:
  /// **'RÉESSAYER'**
  String get commonRetry;

  /// No description provided for @commonLoadingError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de chargement'**
  String get commonLoadingError;

  /// No description provided for @commonNoResults.
  ///
  /// In fr, this message translates to:
  /// **'AUCUN RÉSULTAT'**
  String get commonNoResults;

  /// No description provided for @commonNoResultsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Nous n\'avons rien trouvé pour votre recherche. Essayez d\'autres filtres.'**
  String get commonNoResultsSubtitle;

  /// No description provided for @commonOfflineTitle.
  ///
  /// In fr, this message translates to:
  /// **'MODE HORS-LIGNE'**
  String get commonOfflineTitle;

  /// No description provided for @commonOfflineSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Oups ! Il semble que vous soyez déconnecté. Vérifiez votre connexion internet pour continuer.'**
  String get commonOfflineSubtitle;

  /// No description provided for @commonOfflineAccess.
  ///
  /// In fr, this message translates to:
  /// **'ACCÉDER AUX RÉSERVATIONS HORS-LIGNE'**
  String get commonOfflineAccess;

  /// No description provided for @commonRequiredField.
  ///
  /// In fr, this message translates to:
  /// **'Champ requis'**
  String get commonRequiredField;

  /// No description provided for @commonStart.
  ///
  /// In fr, this message translates to:
  /// **'COMMENCER'**
  String get commonStart;

  /// No description provided for @commonAppNamePart1.
  ///
  /// In fr, this message translates to:
  /// **'BOURGO'**
  String get commonAppNamePart1;

  /// No description provided for @commonAppNamePart2.
  ///
  /// In fr, this message translates to:
  /// **'ARENA'**
  String get commonAppNamePart2;

  /// No description provided for @commonLoadingFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échec du chargement des données. Veuillez réessayer.'**
  String get commonLoadingFailed;

  /// No description provided for @commonGenderMale.
  ///
  /// In fr, this message translates to:
  /// **'Homme'**
  String get commonGenderMale;

  /// No description provided for @commonGenderFemale.
  ///
  /// In fr, this message translates to:
  /// **'Femme'**
  String get commonGenderFemale;

  /// No description provided for @commonGenderOther.
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get commonGenderOther;

  /// No description provided for @commonErrorOccurred.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue. Veuillez réessayer.'**
  String get commonErrorOccurred;

  /// No description provided for @commonImagePickerPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Le sélecteur d\'image s\'ouvrirait ici'**
  String get commonImagePickerPlaceholder;

  /// No description provided for @navHome.
  ///
  /// In fr, this message translates to:
  /// **'ACCUEIL'**
  String get navHome;

  /// No description provided for @navActivities.
  ///
  /// In fr, this message translates to:
  /// **'ACTIVITÉS'**
  String get navActivities;

  /// No description provided for @navPlanning.
  ///
  /// In fr, this message translates to:
  /// **'PLANNING'**
  String get navPlanning;

  /// No description provided for @navProfile.
  ///
  /// In fr, this message translates to:
  /// **'COMPTE'**
  String get navProfile;

  /// No description provided for @homeHeroPart1.
  ///
  /// In fr, this message translates to:
  /// **'REJOIGNEZ'**
  String get homeHeroPart1;

  /// No description provided for @homeHeroPart2.
  ///
  /// In fr, this message translates to:
  /// **'L\'ARÈNE'**
  String get homeHeroPart2;

  /// No description provided for @homeTicker.
  ///
  /// In fr, this message translates to:
  /// **'RÉSERVEZ VOTRE SESSION • FOOTBALL • PADEL • FITNESS • '**
  String get homeTicker;

  /// No description provided for @homeNoCourses.
  ///
  /// In fr, this message translates to:
  /// **'Aucun cours prévu aujourd\'hui.'**
  String get homeNoCourses;

  /// No description provided for @homeActivitiesTitle.
  ///
  /// In fr, this message translates to:
  /// **'NOS ACTIVITÉS'**
  String get homeActivitiesTitle;

  /// No description provided for @homeSeeAll.
  ///
  /// In fr, this message translates to:
  /// **'VOIR TOUT'**
  String get homeSeeAll;

  /// No description provided for @homeTodayTitle.
  ///
  /// In fr, this message translates to:
  /// **'AUJOURD\'HUI'**
  String get homeTodayTitle;

  /// No description provided for @activitiesExplorer.
  ///
  /// In fr, this message translates to:
  /// **'DÉCOUVRIR LE SPORT'**
  String get activitiesExplorer;

  /// No description provided for @activitiesMyReservations.
  ///
  /// In fr, this message translates to:
  /// **'MES RÉSERVATIONS'**
  String get activitiesMyReservations;

  /// No description provided for @activitiesNoReservations.
  ///
  /// In fr, this message translates to:
  /// **'Aucune réservation trouvée.'**
  String get activitiesNoReservations;

  /// No description provided for @activitiesNoReservationsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Prêt à jouer ? Réservez votre première session dès maintenant et rejoignez l\'arène !'**
  String get activitiesNoReservationsSubtitle;

  /// No description provided for @activitiesNoReservationsCTA.
  ///
  /// In fr, this message translates to:
  /// **'RÉSERVER UNE SESSION'**
  String get activitiesNoReservationsCTA;

  /// No description provided for @activitiesRetry.
  ///
  /// In fr, this message translates to:
  /// **'RÉESSAYER'**
  String get activitiesRetry;

  /// No description provided for @activitiesStatusConfirmed.
  ///
  /// In fr, this message translates to:
  /// **'CONFIRMÉ'**
  String get activitiesStatusConfirmed;

  /// No description provided for @activitiesStatusPending.
  ///
  /// In fr, this message translates to:
  /// **'EN ATTENTE'**
  String get activitiesStatusPending;

  /// No description provided for @activitiesStatusCancelled.
  ///
  /// In fr, this message translates to:
  /// **'ANNULÉ'**
  String get activitiesStatusCancelled;

  /// No description provided for @authLogin.
  ///
  /// In fr, this message translates to:
  /// **'SE CONNECTER'**
  String get authLogin;

  /// No description provided for @authRegister.
  ///
  /// In fr, this message translates to:
  /// **'S\'INSCRIRE'**
  String get authRegister;

  /// No description provided for @authForgotPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get authForgotPassword;

  /// No description provided for @authNoAccount.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ? '**
  String get authNoAccount;

  /// No description provided for @authHaveAccount.
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ? '**
  String get authHaveAccount;

  /// No description provided for @authEmailHint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre identifiant'**
  String get authEmailHint;

  /// No description provided for @authPasswordHint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre mot de passe'**
  String get authPasswordHint;

  /// No description provided for @authIdentifierLabel.
  ///
  /// In fr, this message translates to:
  /// **'E-mail ou Téléphone'**
  String get authIdentifierLabel;

  /// No description provided for @authPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get authPasswordLabel;

  /// No description provided for @authLoginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get authLoginTitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Content de vous revoir ! Connectez-vous pour continuer.'**
  String get authLoginSubtitle;

  /// No description provided for @authRegisterTitle.
  ///
  /// In fr, this message translates to:
  /// **'Inscription'**
  String get authRegisterTitle;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Rejoignez le QG du Sport à Djerba et commencez votre aventure.'**
  String get authRegisterSubtitle;

  /// No description provided for @authFullNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom complet'**
  String get authFullNameLabel;

  /// No description provided for @authFullNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre nom'**
  String get authFullNameHint;

  /// No description provided for @authEmailLabel.
  ///
  /// In fr, this message translates to:
  /// **'E-mail'**
  String get authEmailLabel;

  /// No description provided for @authEmailLabelHint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre e-mail'**
  String get authEmailLabelHint;

  /// No description provided for @authPhoneLabel.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get authPhoneLabel;

  /// No description provided for @authPhoneHint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre numéro'**
  String get authPhoneHint;

  /// No description provided for @authPasswordCreateHint.
  ///
  /// In fr, this message translates to:
  /// **'Créez un mot de passe'**
  String get authPasswordCreateHint;

  /// No description provided for @authPasswordMinLength.
  ///
  /// In fr, this message translates to:
  /// **'Min 6 caractères'**
  String get authPasswordMinLength;

  /// No description provided for @authForgotPasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié'**
  String get authForgotPasswordTitle;

  /// No description provided for @authForgotPasswordSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ne vous inquiétez pas ! Entrez votre e-mail ou numéro pour recevoir un code.'**
  String get authForgotPasswordSubtitle;

  /// No description provided for @authVerificationTitle.
  ///
  /// In fr, this message translates to:
  /// **'VÉRIFICATION'**
  String get authVerificationTitle;

  /// No description provided for @authOtpSubtitlePrefix.
  ///
  /// In fr, this message translates to:
  /// **'Entrez le code à 4 chiffres envoyé à '**
  String get authOtpSubtitlePrefix;

  /// No description provided for @authOtpSubtitleDefault.
  ///
  /// In fr, this message translates to:
  /// **'votre numéro'**
  String get authOtpSubtitleDefault;

  /// No description provided for @authOtpResendTimer.
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer le code dans {seconds}s'**
  String authOtpResendTimer(Object seconds);

  /// No description provided for @authNewPasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get authNewPasswordTitle;

  /// No description provided for @authNewPasswordSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Créez un nouveau mot de passe sécurisé pour votre compte.'**
  String get authNewPasswordSubtitle;

  /// No description provided for @authNewPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get authNewPasswordLabel;

  /// No description provided for @authNewPasswordHint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez le nouveau mot de passe'**
  String get authNewPasswordHint;

  /// No description provided for @authConfirmPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get authConfirmPasswordLabel;

  /// No description provided for @authConfirmPasswordHint.
  ///
  /// In fr, this message translates to:
  /// **'Répétez le mot de passe'**
  String get authConfirmPasswordHint;

  /// No description provided for @authPasswordsDoNotMatch.
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe ne correspondent pas'**
  String get authPasswordsDoNotMatch;

  /// No description provided for @authSendCode.
  ///
  /// In fr, this message translates to:
  /// **'ENVOYER LE CODE'**
  String get authSendCode;

  /// No description provided for @authVerify.
  ///
  /// In fr, this message translates to:
  /// **'VÉRIFIER'**
  String get authVerify;

  /// No description provided for @authReset.
  ///
  /// In fr, this message translates to:
  /// **'RÉINITIALISER'**
  String get authReset;

  /// No description provided for @profilePoints.
  ///
  /// In fr, this message translates to:
  /// **'POINTS BOURGO'**
  String get profilePoints;

  /// No description provided for @profileCheckins.
  ///
  /// In fr, this message translates to:
  /// **'VISITES'**
  String get profileCheckins;

  /// No description provided for @profileMySubscription.
  ///
  /// In fr, this message translates to:
  /// **'Mon Adhésion'**
  String get profileMySubscription;

  /// No description provided for @profileHistory.
  ///
  /// In fr, this message translates to:
  /// **'Accès & Historique'**
  String get profileHistory;

  /// No description provided for @profileNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @profileSettings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get profileSettings;

  /// No description provided for @profileLogout.
  ///
  /// In fr, this message translates to:
  /// **'DÉCONNEXION'**
  String get profileLogout;

  /// No description provided for @profileSubscriptionTitle.
  ///
  /// In fr, this message translates to:
  /// **'MON ADHÉSION'**
  String get profileSubscriptionTitle;

  /// No description provided for @profileManageSubscription.
  ///
  /// In fr, this message translates to:
  /// **'GÉRER MON OFFRE'**
  String get profileManageSubscription;

  /// No description provided for @profileAdvantages.
  ///
  /// In fr, this message translates to:
  /// **'MES PRIVILÈGES'**
  String get profileAdvantages;

  /// No description provided for @profileNextBilling.
  ///
  /// In fr, this message translates to:
  /// **'PROCHAINE FACTURATION'**
  String get profileNextBilling;

  /// No description provided for @profileMonthlyUsage.
  ///
  /// In fr, this message translates to:
  /// **'Utilisation mensuelle'**
  String get profileMonthlyUsage;

  /// No description provided for @profilePlanLabel.
  ///
  /// In fr, this message translates to:
  /// **'PLAN'**
  String get profilePlanLabel;

  /// No description provided for @profileBenefit1.
  ///
  /// In fr, this message translates to:
  /// **'Accès illimité à la salle de sport'**
  String get profileBenefit1;

  /// No description provided for @profileBenefit2.
  ///
  /// In fr, this message translates to:
  /// **'Réservation prioritaire des terrains'**
  String get profileBenefit2;

  /// No description provided for @profileBenefit3.
  ///
  /// In fr, this message translates to:
  /// **'1 invité gratuit par mois'**
  String get profileBenefit3;

  /// No description provided for @profileBenefit4.
  ///
  /// In fr, this message translates to:
  /// **'-10% au Pro Shop'**
  String get profileBenefit4;

  /// No description provided for @profileHistoryTitle.
  ///
  /// In fr, this message translates to:
  /// **'ACCÈS & HISTORIQUE'**
  String get profileHistoryTitle;

  /// No description provided for @profileTabCheckin.
  ///
  /// In fr, this message translates to:
  /// **'ACCÈS'**
  String get profileTabCheckin;

  /// No description provided for @profileTabHistory.
  ///
  /// In fr, this message translates to:
  /// **'HISTORIQUE'**
  String get profileTabHistory;

  /// No description provided for @profileQrSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'PRÉSENTEZ VOTRE QR CODE'**
  String get profileQrSubtitle;

  /// No description provided for @profileQrPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'BOURGO-SCAN-123'**
  String get profileQrPlaceholder;

  /// No description provided for @profileQrScanInstruction.
  ///
  /// In fr, this message translates to:
  /// **'Scannez ce code à l\'entrée pour valider votre présence.'**
  String get profileQrScanInstruction;

  /// No description provided for @profileAccessMethods.
  ///
  /// In fr, this message translates to:
  /// **'MÉTHODES D\'ACCÈS'**
  String get profileAccessMethods;

  /// No description provided for @profileAccessPin.
  ///
  /// In fr, this message translates to:
  /// **'Code PIN'**
  String get profileAccessPin;

  /// No description provided for @profileAccessFingerprint.
  ///
  /// In fr, this message translates to:
  /// **'Empreinte digitale'**
  String get profileAccessFingerprint;

  /// No description provided for @profileAccessNfc.
  ///
  /// In fr, this message translates to:
  /// **'Carte NFC'**
  String get profileAccessNfc;

  /// No description provided for @profileStatusConfigured.
  ///
  /// In fr, this message translates to:
  /// **'Configuré'**
  String get profileStatusConfigured;

  /// No description provided for @profileStatusNotConfigured.
  ///
  /// In fr, this message translates to:
  /// **'Non configuré'**
  String get profileStatusNotConfigured;

  /// No description provided for @profileCheckinHistory.
  ///
  /// In fr, this message translates to:
  /// **'HISTORIQUE D\'ACCÈS'**
  String get profileCheckinHistory;

  /// No description provided for @profileCheckinEntry.
  ///
  /// In fr, this message translates to:
  /// **'Entrée enregistrée'**
  String get profileCheckinEntry;

  /// No description provided for @profileNoHistory.
  ///
  /// In fr, this message translates to:
  /// **'Aucune réservation passée.'**
  String get profileNoHistory;

  /// No description provided for @profileNoHistorySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Vos activités et sessions passées apparaîtront ici une fois terminées.'**
  String get profileNoHistorySubtitle;

  /// No description provided for @planningTitle.
  ///
  /// In fr, this message translates to:
  /// **'PLANNING DES COURS'**
  String get planningTitle;

  /// No description provided for @planningFilterTitle.
  ///
  /// In fr, this message translates to:
  /// **'FILTRER PAR CATÉGORIE'**
  String get planningFilterTitle;

  /// No description provided for @planningNoCourses.
  ///
  /// In fr, this message translates to:
  /// **'Aucun cours prévu pour ce jour.'**
  String get planningNoCourses;

  /// No description provided for @planningNoCoursesSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Essayez de sélectionner un autre jour de la semaine ou une catégorie différente pour trouver des sessions disponibles.'**
  String get planningNoCoursesSubtitle;

  /// No description provided for @bookingTitle.
  ///
  /// In fr, this message translates to:
  /// **'RÉSERVATION'**
  String get bookingTitle;

  /// No description provided for @bookingSuccess.
  ///
  /// In fr, this message translates to:
  /// **'RÉSERVATION RÉUSSIE !'**
  String get bookingSuccess;

  /// No description provided for @bookingConfirmed.
  ///
  /// In fr, this message translates to:
  /// **'RÉSERVATION CONFIRMÉE !'**
  String get bookingConfirmed;

  /// No description provided for @bookingReturnHome.
  ///
  /// In fr, this message translates to:
  /// **'RETOUR À L\'ACCUEIL'**
  String get bookingReturnHome;

  /// No description provided for @bookingViewTicket.
  ///
  /// In fr, this message translates to:
  /// **'VOIR LE TICKET'**
  String get bookingViewTicket;

  /// No description provided for @bookingNoSlots.
  ///
  /// In fr, this message translates to:
  /// **'Aucun créneau disponible pour cette date.'**
  String get bookingNoSlots;

  /// No description provided for @bookingPay.
  ///
  /// In fr, this message translates to:
  /// **'PAYER'**
  String get bookingPay;

  /// No description provided for @bookingDateLabel.
  ///
  /// In fr, this message translates to:
  /// **'DATE & HEURE'**
  String get bookingDateLabel;

  /// No description provided for @bookingLocationLabel.
  ///
  /// In fr, this message translates to:
  /// **'LIEU'**
  String get bookingLocationLabel;

  /// No description provided for @bookingSummaryTitle.
  ///
  /// In fr, this message translates to:
  /// **'RÉSUMÉ'**
  String get bookingSummaryTitle;

  /// No description provided for @bookingPaymentTitle.
  ///
  /// In fr, this message translates to:
  /// **'PAIEMENT'**
  String get bookingPaymentTitle;

  /// No description provided for @bookingDate.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get bookingDate;

  /// No description provided for @bookingTime.
  ///
  /// In fr, this message translates to:
  /// **'Créneau'**
  String get bookingTime;

  /// No description provided for @bookingDuration.
  ///
  /// In fr, this message translates to:
  /// **'Durée'**
  String get bookingDuration;

  /// No description provided for @bookingDurationPadel.
  ///
  /// In fr, this message translates to:
  /// **'90 min'**
  String get bookingDurationPadel;

  /// No description provided for @bookingDurationStandard.
  ///
  /// In fr, this message translates to:
  /// **'60 minutes'**
  String get bookingDurationStandard;

  /// No description provided for @bookingMethodCard.
  ///
  /// In fr, this message translates to:
  /// **'Carte Bancaire'**
  String get bookingMethodCard;

  /// No description provided for @bookingMethodWallet.
  ///
  /// In fr, this message translates to:
  /// **'Solde Bourgo Pay'**
  String get bookingMethodWallet;

  /// No description provided for @bookingTotal.
  ///
  /// In fr, this message translates to:
  /// **'TOTAL'**
  String get bookingTotal;

  /// No description provided for @bookingConfirm.
  ///
  /// In fr, this message translates to:
  /// **'CONFIRMER'**
  String get bookingConfirm;

  /// No description provided for @bookingCurrency.
  ///
  /// In fr, this message translates to:
  /// **'TND'**
  String get bookingCurrency;

  /// No description provided for @bookingToPay.
  ///
  /// In fr, this message translates to:
  /// **'TND (À payer)'**
  String get bookingToPay;

  /// No description provided for @bookingSuccessMessagePrefix.
  ///
  /// In fr, this message translates to:
  /// **'Votre terrain de '**
  String get bookingSuccessMessagePrefix;

  /// No description provided for @bookingSuccessMessageSuffix.
  ///
  /// In fr, this message translates to:
  /// **' a été réservé avec succès.'**
  String get bookingSuccessMessageSuffix;

  /// No description provided for @bookingSportDefault.
  ///
  /// In fr, this message translates to:
  /// **'Sport'**
  String get bookingSportDefault;

  /// No description provided for @bookingLocationValue.
  ///
  /// In fr, this message translates to:
  /// **'Bourgo Arena, Djerba'**
  String get bookingLocationValue;

  /// No description provided for @bookingTodayAt.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui à 18:30'**
  String get bookingTodayAt;

  /// No description provided for @commonMon.
  ///
  /// In fr, this message translates to:
  /// **'LUN'**
  String get commonMon;

  /// No description provided for @commonTue.
  ///
  /// In fr, this message translates to:
  /// **'MAR'**
  String get commonTue;

  /// No description provided for @commonWed.
  ///
  /// In fr, this message translates to:
  /// **'MER'**
  String get commonWed;

  /// No description provided for @commonThu.
  ///
  /// In fr, this message translates to:
  /// **'JEU'**
  String get commonThu;

  /// No description provided for @commonFri.
  ///
  /// In fr, this message translates to:
  /// **'VEN'**
  String get commonFri;

  /// No description provided for @commonSat.
  ///
  /// In fr, this message translates to:
  /// **'SAM'**
  String get commonSat;

  /// No description provided for @commonSun.
  ///
  /// In fr, this message translates to:
  /// **'DIM'**
  String get commonSun;

  /// No description provided for @notificationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'NOTIFICATIONS'**
  String get notificationsTitle;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In fr, this message translates to:
  /// **'TOUT LIRE'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune notification pour le moment.'**
  String get notificationsEmpty;

  /// No description provided for @notificationsEmptySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Nous vous préviendrons ici lorsque vous aurez une nouvelle réservation ou une offre spéciale.'**
  String get notificationsEmptySubtitle;

  /// No description provided for @planningCategoryAll.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get planningCategoryAll;

  /// No description provided for @planningCategoryFitness.
  ///
  /// In fr, this message translates to:
  /// **'Fitness'**
  String get planningCategoryFitness;

  /// No description provided for @planningCategoryAcademy.
  ///
  /// In fr, this message translates to:
  /// **'Academy'**
  String get planningCategoryAcademy;

  /// No description provided for @planningCategoryWellness.
  ///
  /// In fr, this message translates to:
  /// **'Wellness'**
  String get planningCategoryWellness;

  /// No description provided for @bookingStepSport.
  ///
  /// In fr, this message translates to:
  /// **'SPORT'**
  String get bookingStepSport;

  /// No description provided for @bookingStepTime.
  ///
  /// In fr, this message translates to:
  /// **'HORAIRE'**
  String get bookingStepTime;

  /// No description provided for @bookingStepPayment.
  ///
  /// In fr, this message translates to:
  /// **'PAIEMENT'**
  String get bookingStepPayment;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'PARAMÈTRES'**
  String get settingsTitle;

  /// No description provided for @settingsSectionAccount.
  ///
  /// In fr, this message translates to:
  /// **'COMPTE'**
  String get settingsSectionAccount;

  /// No description provided for @settingsSectionPreferences.
  ///
  /// In fr, this message translates to:
  /// **'PRÉFÉRENCES'**
  String get settingsSectionPreferences;

  /// No description provided for @settingsSectionLegal.
  ///
  /// In fr, this message translates to:
  /// **'LÉGAL'**
  String get settingsSectionLegal;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In fr, this message translates to:
  /// **'À PROPOS'**
  String get settingsSectionAbout;

  /// No description provided for @settingsEditProfile.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le profil'**
  String get settingsEditProfile;

  /// No description provided for @settingsManageFamily.
  ///
  /// In fr, this message translates to:
  /// **'Gérer la famille'**
  String get settingsManageFamily;

  /// No description provided for @settingsChangePassword.
  ///
  /// In fr, this message translates to:
  /// **'Changer le mot de passe'**
  String get settingsChangePassword;

  /// No description provided for @settingsLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue de l\'app'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In fr, this message translates to:
  /// **'Mode d\'affichage'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In fr, this message translates to:
  /// **'Défaut Système'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In fr, this message translates to:
  /// **'Mode Clair'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In fr, this message translates to:
  /// **'Mode Sombre'**
  String get settingsThemeDark;

  /// No description provided for @settingsPushNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications Push'**
  String get settingsPushNotifications;

  /// No description provided for @settingsTerms.
  ///
  /// In fr, this message translates to:
  /// **'Conditions d\'utilisation'**
  String get settingsTerms;

  /// No description provided for @settingsPrivacy.
  ///
  /// In fr, this message translates to:
  /// **'Politique de confidentialité'**
  String get settingsPrivacy;

  /// No description provided for @settingsAppVersion.
  ///
  /// In fr, this message translates to:
  /// **'Version'**
  String get settingsAppVersion;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le compte'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsConfirmDeleteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le compte ?'**
  String get settingsConfirmDeleteTitle;

  /// No description provided for @settingsConfirmDeleteMessage.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est irréversible. Toutes vos données seront définitivement supprimées.'**
  String get settingsConfirmDeleteMessage;

  /// No description provided for @settingsDelete.
  ///
  /// In fr, this message translates to:
  /// **'SUPPRIMER'**
  String get settingsDelete;

  /// No description provided for @settingsCancel.
  ///
  /// In fr, this message translates to:
  /// **'ANNULER'**
  String get settingsCancel;

  /// No description provided for @profileEditTitle.
  ///
  /// In fr, this message translates to:
  /// **'MODIFIER LE PROFIL'**
  String get profileEditTitle;

  /// No description provided for @profileSave.
  ///
  /// In fr, this message translates to:
  /// **'ENREGISTRER'**
  String get profileSave;

  /// No description provided for @profileUpdateSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Profil mis à jour avec succès !'**
  String get profileUpdateSuccess;

  /// No description provided for @passwordChangeTitle.
  ///
  /// In fr, this message translates to:
  /// **'CHANGER LE MOT DE PASSE'**
  String get passwordChangeTitle;

  /// No description provided for @passwordCurrentLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe actuel'**
  String get passwordCurrentLabel;

  /// No description provided for @passwordCurrentHint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre mot de passe actuel'**
  String get passwordCurrentHint;

  /// No description provided for @passwordUpdateSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe mis à jour avec succès!'**
  String get passwordUpdateSuccess;

  /// No description provided for @authFirstNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Prénom'**
  String get authFirstNameLabel;

  /// No description provided for @authFirstNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre prénom'**
  String get authFirstNameHint;

  /// No description provided for @authLastNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get authLastNameLabel;

  /// No description provided for @authLastNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre nom'**
  String get authLastNameHint;

  /// No description provided for @authBirthDateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date de naissance'**
  String get authBirthDateLabel;

  /// No description provided for @authBirthDateHint.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez votre date de naissance'**
  String get authBirthDateHint;

  /// No description provided for @profileFamilyAccount.
  ///
  /// In fr, this message translates to:
  /// **'Compte Famille'**
  String get profileFamilyAccount;

  /// No description provided for @profileEnableFamilyAccount.
  ///
  /// In fr, this message translates to:
  /// **'Activer le compte famille'**
  String get profileEnableFamilyAccount;

  /// No description provided for @profileFamilyAccountDescription.
  ///
  /// In fr, this message translates to:
  /// **'Gérez les profils et activités de vos enfants.'**
  String get profileFamilyAccountDescription;

  /// No description provided for @profileAddChild.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un enfant'**
  String get profileAddChild;

  /// No description provided for @profileNoChildren.
  ///
  /// In fr, this message translates to:
  /// **'Aucun profil d\'enfant ajouté.'**
  String get profileNoChildren;

  /// No description provided for @profileChildName.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'enfant'**
  String get profileChildName;

  /// No description provided for @profileChildBirthDate.
  ///
  /// In fr, this message translates to:
  /// **'Date de naissance de l\'enfant'**
  String get profileChildBirthDate;

  /// No description provided for @profileVerifyFamilyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier le compte famille'**
  String get profileVerifyFamilyTitle;

  /// No description provided for @profileVerifyFamilySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Pour activer le compte famille, nous devons vérifier votre identité. Entrez le code envoyé à votre {identifier}.'**
  String profileVerifyFamilySubtitle(Object identifier);

  /// No description provided for @profileFamilyEnabled.
  ///
  /// In fr, this message translates to:
  /// **'Compte famille activé avec succès !'**
  String get profileFamilyEnabled;

  /// No description provided for @authVerificationMethodTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérification de Sécurité'**
  String get authVerificationMethodTitle;

  /// No description provided for @authVerificationMethodSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez une méthode pour recevoir votre code de vérification.'**
  String get authVerificationMethodSubtitle;

  /// No description provided for @authEmailMethod.
  ///
  /// In fr, this message translates to:
  /// **'Adresse E-mail'**
  String get authEmailMethod;

  /// No description provided for @authPhoneMethod.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de Téléphone'**
  String get authPhoneMethod;

  /// No description provided for @authMethodAccessInstruction.
  ///
  /// In fr, this message translates to:
  /// **'Assurez-vous d\'avoir accès à la méthode sélectionnée.'**
  String get authMethodAccessInstruction;

  /// No description provided for @authFamilyOnboardingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Membres de la Famille'**
  String get authFamilyOnboardingTitle;

  /// No description provided for @authFamilyOnboardingSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez les détails de vos membres de famille (Optionnel).'**
  String get authFamilyOnboardingSubtitle;

  /// No description provided for @authAddMember.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un membre'**
  String get authAddMember;

  /// No description provided for @authAddedMembers.
  ///
  /// In fr, this message translates to:
  /// **'Membres ajoutés'**
  String get authAddedMembers;

  /// No description provided for @authDoItLater.
  ///
  /// In fr, this message translates to:
  /// **'Plus tard'**
  String get authDoItLater;

  /// No description provided for @authAccountOverviewTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aperçu du Compte'**
  String get authAccountOverviewTitle;

  /// No description provided for @authAccountOverviewSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez vos informations et téléchargez une photo de profil.'**
  String get authAccountOverviewSubtitle;

  /// No description provided for @authProfilePictureRecommendation.
  ///
  /// In fr, this message translates to:
  /// **'Nous vous recommandons de télécharger une photo claire de vous-même pour être reconnu à l\'entrée de l\'arène.'**
  String get authProfilePictureRecommendation;

  /// No description provided for @authConfirmContinue.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer et continuer'**
  String get authConfirmContinue;

  /// No description provided for @authEditInformation.
  ///
  /// In fr, this message translates to:
  /// **'Modifier les informations'**
  String get authEditInformation;

  /// No description provided for @authPinSetupTitle.
  ///
  /// In fr, this message translates to:
  /// **'Code PIN Sécurisé'**
  String get authPinSetupTitle;

  /// No description provided for @authPinSetupSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Créez un code PIN à 4 chiffres pour votre premier accès.'**
  String get authPinSetupSubtitle;

  /// No description provided for @authPinSetupInstruction.
  ///
  /// In fr, this message translates to:
  /// **'Ce code PIN sera utilisé aux bornes de la salle.'**
  String get authPinSetupInstruction;

  /// No description provided for @authCompleteRegistration.
  ///
  /// In fr, this message translates to:
  /// **'Terminer l\'inscription'**
  String get authCompleteRegistration;

  /// No description provided for @languageSelectionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue à Bourgo Arena'**
  String get languageSelectionTitle;

  /// No description provided for @languageSelectionSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner votre langue préférée pour continuer'**
  String get languageSelectionSubtitle;

  /// No description provided for @languageLabel.
  ///
  /// In fr, this message translates to:
  /// **'Choisir la langue'**
  String get languageLabel;

  /// No description provided for @languageEnglish.
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageFrench.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @authGenderLabel.
  ///
  /// In fr, this message translates to:
  /// **'Genre'**
  String get authGenderLabel;

  /// No description provided for @authGenderHint.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez le genre'**
  String get authGenderHint;

  /// No description provided for @errorNotFoundTitle.
  ///
  /// In fr, this message translates to:
  /// **'PAGE INTROUVABLE'**
  String get errorNotFoundTitle;

  /// No description provided for @errorNotFoundSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Oups ! La page que vous cherchez n\'existe pas ou a été déplacée.'**
  String get errorNotFoundSubtitle;

  /// No description provided for @errorNotFoundAction.
  ///
  /// In fr, this message translates to:
  /// **'RETOUR À L\'ACCUEIL'**
  String get errorNotFoundAction;

  /// No description provided for @profileDisableFamilyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Désactiver le compte famille ?'**
  String get profileDisableFamilyTitle;

  /// No description provided for @profileDisableFamilyContent.
  ///
  /// In fr, this message translates to:
  /// **'Cela masquera tous les profils d\'enfants et les fonctionnalités. Êtes-vous sûr de vouloir continuer ?'**
  String get profileDisableFamilyContent;

  /// No description provided for @profileDisableConfirm.
  ///
  /// In fr, this message translates to:
  /// **'DÉSACTIVER'**
  String get profileDisableConfirm;

  /// No description provided for @commonCancel.
  ///
  /// In fr, this message translates to:
  /// **'ANNULER'**
  String get commonCancel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
