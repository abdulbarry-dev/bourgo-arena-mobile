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

  /// No description provided for @commonErrorOccurred.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue. Veuillez réessayer.'**
  String get commonErrorOccurred;

  /// No description provided for @commonSave.
  ///
  /// In fr, this message translates to:
  /// **'ENREGISTRER'**
  String get commonSave;

  /// No description provided for @commonMissingContactInfo.
  ///
  /// In fr, this message translates to:
  /// **'Informations de contact manquantes.'**
  String get commonMissingContactInfo;

  /// No description provided for @commonImagePickerPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Le sélecteur d\'image s\'ouvrirait ici'**
  String get commonImagePickerPlaceholder;

  /// No description provided for @commonMe.
  ///
  /// In fr, this message translates to:
  /// **'Moi'**
  String get commonMe;

  /// No description provided for @commonSetUp.
  ///
  /// In fr, this message translates to:
  /// **'CONFIGURER'**
  String get commonSetUp;

  /// No description provided for @commonPointsShort.
  ///
  /// In fr, this message translates to:
  /// **'pts'**
  String get commonPointsShort;

  /// No description provided for @guestBrowse.
  ///
  /// In fr, this message translates to:
  /// **'CONTINUER EN TANT QU\'INVITÉ'**
  String get guestBrowse;

  /// No description provided for @navHome.
  ///
  /// In fr, this message translates to:
  /// **'ACCUEIL'**
  String get navHome;

  /// No description provided for @navActivities.
  ///
  /// In fr, this message translates to:
  /// **'PARCOURIR'**
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

  /// No description provided for @homeActivitiesEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune activité disponible.'**
  String get homeActivitiesEmpty;

  /// No description provided for @homeActivitiesEmptySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Revenez plus tard pour découvrir de nouveaux sports.'**
  String get homeActivitiesEmptySubtitle;

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

  /// No description provided for @activitiesNoSportsFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucun sport trouvé.'**
  String get activitiesNoSportsFound;

  /// No description provided for @activitiesNoSportsFoundSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Réessayez plus tard ou explorez une autre catégorie.'**
  String get activitiesNoSportsFoundSubtitle;

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

  /// No description provided for @authDeletionCancelSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre compte est programmé pour suppression. Entrez le code envoyé à votre e-mail/téléphone pour annuler la demande.'**
  String get authDeletionCancelSubtitle;

  /// No description provided for @authRememberMe.
  ///
  /// In fr, this message translates to:
  /// **'Se souvenir de moi'**
  String get authRememberMe;

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
  /// **'Entrez le code à 6 chiffres envoyé à '**
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
  /// **'Accès et historique'**
  String get profileHistory;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le compte'**
  String get profileDeleteAccount;

  /// No description provided for @profileDeleteAccountTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le compte'**
  String get profileDeleteAccountTitle;

  /// No description provided for @profileDeleteAccountSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est permanente'**
  String get profileDeleteAccountSubtitle;

  /// No description provided for @profileDeleteAccountMessage.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible et votre compte sera traité pour suppression.'**
  String get profileDeleteAccountMessage;

  /// No description provided for @profileDeleteAccountConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer mon compte'**
  String get profileDeleteAccountConfirm;

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

  /// No description provided for @months.
  ///
  /// In fr, this message translates to:
  /// **'mois'**
  String get months;

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

  /// No description provided for @profileNoCheckins.
  ///
  /// In fr, this message translates to:
  /// **'Aucun historique d\'accès pour le moment.'**
  String get profileNoCheckins;

  /// No description provided for @profileNoCheckinsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Vos passages apparaîtront ici une fois que vous entrerez dans l\'arène.'**
  String get profileNoCheckinsSubtitle;

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

  /// No description provided for @bookingStepMember.
  ///
  /// In fr, this message translates to:
  /// **'MEMBRE'**
  String get bookingStepMember;

  /// No description provided for @bookingMemberSelectSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un profil pour le tarif et l’éligibilité.'**
  String get bookingMemberSelectSubtitle;

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

  /// No description provided for @bookingStepDetails.
  ///
  /// In fr, this message translates to:
  /// **'DÉTAILS'**
  String get bookingStepDetails;

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

  /// No description provided for @settingsEnterPasswordFirst.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez saisir votre mot de passe actuel pour confirmer la suppression.'**
  String get settingsEnterPasswordFirst;

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

  /// No description provided for @profileEditSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Mettez à jour vos informations et les détails de votre profil.'**
  String get profileEditSubtitle;

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

  /// No description provided for @errorUpdatingProfile.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la mise à jour du profil'**
  String get errorUpdatingProfile;

  /// No description provided for @errorUpdatingPassword.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la mise à jour du mot de passe'**
  String get errorUpdatingPassword;

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

  /// No description provided for @profileEditChild.
  ///
  /// In fr, this message translates to:
  /// **'Modifier l\'enfant'**
  String get profileEditChild;

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

  /// No description provided for @profileFamilyNotEnabled.
  ///
  /// In fr, this message translates to:
  /// **'Activez le compte famille pour gérer les profils de vos enfants.'**
  String get profileFamilyNotEnabled;

  /// No description provided for @profileManageChildren.
  ///
  /// In fr, this message translates to:
  /// **'Gérer les enfants'**
  String get profileManageChildren;

  /// No description provided for @profileEdit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get profileEdit;

  /// No description provided for @profileDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get profileDelete;

  /// No description provided for @profileConfirmDeleteChild.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer l\'enfant ?'**
  String get profileConfirmDeleteChild;

  /// No description provided for @profileConfirmDeleteChildMessage.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer {childName} de votre compte famille ? Cette action ne peut pas être annulée.'**
  String profileConfirmDeleteChildMessage(String childName);

  /// No description provided for @profileChildRemoved.
  ///
  /// In fr, this message translates to:
  /// **'Profil d\'enfant supprimé avec succès.'**
  String get profileChildRemoved;

  /// No description provided for @profileChildAdded.
  ///
  /// In fr, this message translates to:
  /// **'Profil d\'enfant ajouté avec succès.'**
  String get profileChildAdded;

  /// No description provided for @profileChildUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Profil d\'enfant mis à jour avec succès.'**
  String get profileChildUpdated;

  /// No description provided for @profileFirstName.
  ///
  /// In fr, this message translates to:
  /// **'Prénom'**
  String get profileFirstName;

  /// No description provided for @profileFirstNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez le prénom de l\'enfant'**
  String get profileFirstNameHint;

  /// No description provided for @profileLastName.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get profileLastName;

  /// No description provided for @profileLastNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez le nom de l\'enfant'**
  String get profileLastNameHint;

  /// No description provided for @profileGender.
  ///
  /// In fr, this message translates to:
  /// **'Genre'**
  String get profileGender;

  /// No description provided for @profileMale.
  ///
  /// In fr, this message translates to:
  /// **'Garçon'**
  String get profileMale;

  /// No description provided for @profileFemale.
  ///
  /// In fr, this message translates to:
  /// **'Fille'**
  String get profileFemale;

  /// No description provided for @profileGenderNotSpecified.
  ///
  /// In fr, this message translates to:
  /// **'Non spécifié'**
  String get profileGenderNotSpecified;

  /// No description provided for @profileBirthDate.
  ///
  /// In fr, this message translates to:
  /// **'Date de naissance'**
  String get profileBirthDate;

  /// No description provided for @profileSelectDate.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez la date de naissance'**
  String get profileSelectDate;

  /// No description provided for @profileNoChildrenDescription.
  ///
  /// In fr, this message translates to:
  /// **'Commencez par ajouter le profil de votre enfant pour gérer ses activités.'**
  String get profileNoChildrenDescription;

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

  /// No description provided for @profileNoVerifiedOtpMethod.
  ///
  /// In fr, this message translates to:
  /// **'Vous devez avoir au moins une méthode de contact vérifiée (e-mail ou téléphone) avant d\'activer un compte famille.'**
  String get profileNoVerifiedOtpMethod;

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

  /// No description provided for @authSetupRequiredTitle.
  ///
  /// In fr, this message translates to:
  /// **'Configuration du compte requise'**
  String get authSetupRequiredTitle;

  /// No description provided for @authSetupRequiredMessage.
  ///
  /// In fr, this message translates to:
  /// **'La configuration du compte n\'est pas terminée. Veuillez compléter votre profil pour déverrouiller votre compte.'**
  String get authSetupRequiredMessage;

  /// No description provided for @authCompleteSetup.
  ///
  /// In fr, this message translates to:
  /// **'Compléter la configuration'**
  String get authCompleteSetup;

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

  /// No description provided for @profileStandardTier.
  ///
  /// In fr, this message translates to:
  /// **'Standard'**
  String get profileStandardTier;

  /// No description provided for @authInvalidVerificationCode.
  ///
  /// In fr, this message translates to:
  /// **'Code de vérification invalide'**
  String get authInvalidVerificationCode;

  /// No description provided for @searchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher des activités, cours, paramètres...'**
  String get searchHint;

  /// No description provided for @searchRecentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Recherche globale'**
  String get searchRecentTitle;

  /// No description provided for @searchRecentSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Trouvez des activités, cours ou paramètres dans l\'app.'**
  String get searchRecentSubtitle;

  /// No description provided for @searchNoResultsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat pour \"{query}\"'**
  String searchNoResultsTitle(String query);

  /// No description provided for @searchNoResultsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Essayez d\'autres mots-clés ou vérifiez l\'orthographe.'**
  String get searchNoResultsSubtitle;

  /// No description provided for @subscriptionSelectPlanTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez une offre'**
  String get subscriptionSelectPlanTitle;

  /// No description provided for @subscriptionPlanBasic.
  ///
  /// In fr, this message translates to:
  /// **'Basic'**
  String get subscriptionPlanBasic;

  /// No description provided for @subscriptionPlanPremium.
  ///
  /// In fr, this message translates to:
  /// **'Premium'**
  String get subscriptionPlanPremium;

  /// No description provided for @subscriptionConfirmPlan.
  ///
  /// In fr, this message translates to:
  /// **'CONFIRMER L\'OFFRE'**
  String get subscriptionConfirmPlan;

  /// No description provided for @subscriptionPricePerMonth.
  ///
  /// In fr, this message translates to:
  /// **'{price} TND / mois'**
  String subscriptionPricePerMonth(String price);

  /// No description provided for @profileOtpCodeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Code OTP'**
  String get profileOtpCodeLabel;

  /// No description provided for @profileOtpCodeHint.
  ///
  /// In fr, this message translates to:
  /// **'000000'**
  String get profileOtpCodeHint;

  /// No description provided for @bookingPointsToEarned.
  ///
  /// In fr, this message translates to:
  /// **'Points à gagner'**
  String get bookingPointsToEarned;

  /// No description provided for @courseFull.
  ///
  /// In fr, this message translates to:
  /// **'COMPLET'**
  String get courseFull;

  /// No description provided for @courseRemaining.
  ///
  /// In fr, this message translates to:
  /// **'{remaining} RESTANT'**
  String courseRemaining(String remaining);

  /// No description provided for @loyaltyDashboardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Programme de fidélité'**
  String get loyaltyDashboardTitle;

  /// No description provided for @loyaltyTotalPoints.
  ///
  /// In fr, this message translates to:
  /// **'Points totaux'**
  String get loyaltyTotalPoints;

  /// No description provided for @loyaltyGoldMember.
  ///
  /// In fr, this message translates to:
  /// **'Membre Or'**
  String get loyaltyGoldMember;

  /// No description provided for @loyaltyPointsToPlatinum.
  ///
  /// In fr, this message translates to:
  /// **'{points} points avant le niveau Platine'**
  String loyaltyPointsToPlatinum(String points);

  /// No description provided for @profileLogoutTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vous déconnecter ?'**
  String get profileLogoutTitle;

  /// No description provided for @profileLogoutMessage.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir vous déconnecter ? Vous devrez vous reconnecter pour accéder à votre compte.'**
  String get profileLogoutMessage;

  /// No description provided for @profileLogoutConfirm.
  ///
  /// In fr, this message translates to:
  /// **'DÉCONNEXION'**
  String get profileLogoutConfirm;

  /// No description provided for @profileLogoutSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez été déconnecté avec succès'**
  String get profileLogoutSuccess;

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

  /// No description provided for @legalLastUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Dernière mise à jour : mai 2026'**
  String get legalLastUpdated;

  /// No description provided for @privacyPolicySection1Title.
  ///
  /// In fr, this message translates to:
  /// **'1. Collecte des informations'**
  String get privacyPolicySection1Title;

  /// No description provided for @privacyPolicySection1Content.
  ///
  /// In fr, this message translates to:
  /// **'Nous collectons les informations personnelles que vous nous fournissez, comme votre nom, votre adresse e-mail, votre numéro de téléphone et vos informations de paiement lorsque vous vous inscrivez ou utilisez nos services.'**
  String get privacyPolicySection1Content;

  /// No description provided for @privacyPolicySection2Title.
  ///
  /// In fr, this message translates to:
  /// **'2. Utilisation des informations'**
  String get privacyPolicySection2Title;

  /// No description provided for @privacyPolicySection2Content.
  ///
  /// In fr, this message translates to:
  /// **'Vos informations sont utilisées pour fournir et améliorer nos services, traiter les paiements, envoyer des notifications sur vos réservations et communiquer avec vous au sujet des mises à jour ou des offres.'**
  String get privacyPolicySection2Content;

  /// No description provided for @privacyPolicySection3Title.
  ///
  /// In fr, this message translates to:
  /// **'3. Sécurité des données'**
  String get privacyPolicySection3Title;

  /// No description provided for @privacyPolicySection3Content.
  ///
  /// In fr, this message translates to:
  /// **'Nous mettons en place des mesures de sécurité conformes aux normes du secteur pour protéger vos données personnelles. Cependant, aucune méthode de transmission sur Internet n\'est sécurisée à 100 %.'**
  String get privacyPolicySection3Content;

  /// No description provided for @privacyPolicySection4Title.
  ///
  /// In fr, this message translates to:
  /// **'4. Services tiers'**
  String get privacyPolicySection4Title;

  /// No description provided for @privacyPolicySection4Content.
  ///
  /// In fr, this message translates to:
  /// **'Nous pouvons faire appel à des prestataires tiers pour faciliter nos services, comme les processeurs de paiement. Ces tiers n\'ont accès à vos informations que pour effectuer des tâches spécifiques en notre nom.'**
  String get privacyPolicySection4Content;

  /// No description provided for @privacyPolicySection5Title.
  ///
  /// In fr, this message translates to:
  /// **'5. Vos droits'**
  String get privacyPolicySection5Title;

  /// No description provided for @privacyPolicySection5Content.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez le droit d\'accéder à vos informations personnelles, de les mettre à jour ou de les supprimer à tout moment via les paramètres de l\'application ou en contactant notre équipe d\'assistance.'**
  String get privacyPolicySection5Content;

  /// No description provided for @privacyPolicySection6Title.
  ///
  /// In fr, this message translates to:
  /// **'6. Cookies et suivi'**
  String get privacyPolicySection6Title;

  /// No description provided for @privacyPolicySection6Content.
  ///
  /// In fr, this message translates to:
  /// **'Nous utilisons des cookies et des technologies de suivi similaires pour suivre l\'activité sur notre service et conserver certaines informations afin d\'améliorer votre expérience.'**
  String get privacyPolicySection6Content;

  /// No description provided for @termsSection1Title.
  ///
  /// In fr, this message translates to:
  /// **'1. Acceptation des conditions'**
  String get termsSection1Title;

  /// No description provided for @termsSection1Content.
  ///
  /// In fr, this message translates to:
  /// **'En accédant aux services Bourgo Arena ou en les utilisant, vous acceptez d\'être lié par ces conditions. Si vous n\'êtes pas d\'accord, veuillez ne pas utiliser l\'application.'**
  String get termsSection1Content;

  /// No description provided for @termsSection2Title.
  ///
  /// In fr, this message translates to:
  /// **'2. Description du service'**
  String get termsSection2Title;

  /// No description provided for @termsSection2Content.
  ///
  /// In fr, this message translates to:
  /// **'Bourgo Arena fournit une plateforme pour réserver des installations sportives, gérer des adhésions à la salle et participer à des cours de fitness programmés à Djerba, en Tunisie.'**
  String get termsSection2Content;

  /// No description provided for @termsSection3Title.
  ///
  /// In fr, this message translates to:
  /// **'3. Responsabilités de l\'utilisateur'**
  String get termsSection3Title;

  /// No description provided for @termsSection3Content.
  ///
  /// In fr, this message translates to:
  /// **'Les utilisateurs sont responsables de la confidentialité de leurs comptes et de toutes les activités effectuées avec leurs identifiants. Vous acceptez de respecter les règles de la salle et les autres membres.'**
  String get termsSection3Content;

  /// No description provided for @termsSection4Title.
  ///
  /// In fr, this message translates to:
  /// **'4. Réservations et paiements'**
  String get termsSection4Title;

  /// No description provided for @termsSection4Content.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les réservations sont soumises à disponibilité. Les paiements effectués via l\'application sont traités de manière sécurisée. Les annulations doivent respecter notre politique d\'annulation pour être remboursables.'**
  String get termsSection4Content;

  /// No description provided for @termsSection5Title.
  ///
  /// In fr, this message translates to:
  /// **'5. Limitation de responsabilité'**
  String get termsSection5Title;

  /// No description provided for @termsSection5Content.
  ///
  /// In fr, this message translates to:
  /// **'Bourgo Arena n\'est pas responsable des blessures corporelles ou des dommages matériels subis lors de l\'utilisation des installations, sauf en cas de négligence grave de notre part.'**
  String get termsSection5Content;

  /// No description provided for @termsSection6Title.
  ///
  /// In fr, this message translates to:
  /// **'6. Modifications des conditions'**
  String get termsSection6Title;

  /// No description provided for @termsSection6Content.
  ///
  /// In fr, this message translates to:
  /// **'Nous nous réservons le droit de modifier ces conditions à tout moment. Le fait de continuer à utiliser l\'application après ces modifications vaut acceptation des nouvelles conditions.'**
  String get termsSection6Content;

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

  /// No description provided for @commonContinue.
  ///
  /// In fr, this message translates to:
  /// **'CONTINUER'**
  String get commonContinue;

  /// No description provided for @authVerifyAdditionalMethodTitle.
  ///
  /// In fr, this message translates to:
  /// **'Complétez votre vérification'**
  String get authVerifyAdditionalMethodTitle;

  /// No description provided for @authVerifyAdditionalMethodMessage.
  ///
  /// In fr, this message translates to:
  /// **'Pour assurer la sécurité de votre compte, veuillez vérifier votre {method}.'**
  String authVerifyAdditionalMethodMessage(Object method);

  /// No description provided for @authVerifyNow.
  ///
  /// In fr, this message translates to:
  /// **'VÉRIFIER MAINTENANT'**
  String get authVerifyNow;

  /// No description provided for @authSkipForNow.
  ///
  /// In fr, this message translates to:
  /// **'PLUS TARD'**
  String get authSkipForNow;

  /// No description provided for @authEmailVerificationPending.
  ///
  /// In fr, this message translates to:
  /// **'Vérification email en attente'**
  String get authEmailVerificationPending;

  /// No description provided for @authPhoneVerificationPending.
  ///
  /// In fr, this message translates to:
  /// **'Vérification téléphone en attente'**
  String get authPhoneVerificationPending;

  /// No description provided for @authBothMethodsVerified.
  ///
  /// In fr, this message translates to:
  /// **'Email et téléphone sont tous deux vérifiés'**
  String get authBothMethodsVerified;

  /// No description provided for @authOneMethodVerified.
  ///
  /// In fr, this message translates to:
  /// **'Une méthode vérifiée, une en attente'**
  String get authOneMethodVerified;

  /// No description provided for @authVerifyPhoneTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier le numéro de téléphone'**
  String get authVerifyPhoneTitle;

  /// No description provided for @authVerifyPhoneSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Nous enverrons un code à 6 chiffres à votre téléphone {phone}.'**
  String authVerifyPhoneSubtitle(Object phone);

  /// No description provided for @authVerifyEmailTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier l\'adresse e-mail'**
  String get authVerifyEmailTitle;

  /// No description provided for @authVerifyEmailSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Nous enverrons un code à 6 chiffres à votre e-mail {email}.'**
  String authVerifyEmailSubtitle(Object email);

  /// No description provided for @authVerificationCompleteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérification terminée'**
  String get authVerificationCompleteTitle;

  /// No description provided for @authVerificationCompleteMessage.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les méthodes de vérification ont été vérifiées avec succès. Poursuivons avec la configuration de votre profil.'**
  String get authVerificationCompleteMessage;

  /// No description provided for @authDontShowAgain.
  ///
  /// In fr, this message translates to:
  /// **'Ne plus afficher'**
  String get authDontShowAgain;

  /// No description provided for @authSkipForever.
  ///
  /// In fr, this message translates to:
  /// **'PASSER DÉFINITIVEMENT'**
  String get authSkipForever;

  /// No description provided for @authSkipForeverMessage.
  ///
  /// In fr, this message translates to:
  /// **'Nous recommandons de vérifier les deux méthodes pour une sécurité maximale. Vous pourrez toujours le faire plus tard dans les paramètres.'**
  String get authSkipForeverMessage;

  /// No description provided for @loyaltyRecentTransactions.
  ///
  /// In fr, this message translates to:
  /// **'Transactions récentes'**
  String get loyaltyRecentTransactions;

  /// No description provided for @loyaltyNoTransactions.
  ///
  /// In fr, this message translates to:
  /// **'Aucune transaction'**
  String get loyaltyNoTransactions;

  /// No description provided for @loyaltyNoTransactionsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez pas encore gagné ou dépensé de points. Commencez à réserver des cours pour gagner des points !'**
  String get loyaltyNoTransactionsSubtitle;

  /// No description provided for @themeSelectionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez votre style'**
  String get themeSelectionTitle;

  /// No description provided for @themeSelectionSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Personnalisez l\'apparence de l\'application selon vos préférences.'**
  String get themeSelectionSubtitle;

  /// No description provided for @activitiesTitle.
  ///
  /// In fr, this message translates to:
  /// **'ACTIVITÉS'**
  String get activitiesTitle;

  /// No description provided for @coursesTitle.
  ///
  /// In fr, this message translates to:
  /// **'COURS'**
  String get coursesTitle;

  /// No description provided for @coursesSubscriptionRequired.
  ///
  /// In fr, this message translates to:
  /// **'Certains cours nécessitent un abonnement pour réserver des séances.'**
  String get coursesSubscriptionRequired;

  /// No description provided for @coursesViewOffers.
  ///
  /// In fr, this message translates to:
  /// **'VOIR LES OFFRES'**
  String get coursesViewOffers;

  /// No description provided for @childSelectorTitle.
  ///
  /// In fr, this message translates to:
  /// **'POUR QUI EST-CE ?'**
  String get childSelectorTitle;

  /// No description provided for @childSelectorSelfDesc.
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire pour soi-même'**
  String get childSelectorSelfDesc;

  /// No description provided for @childSelectorNoChildrenTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun enfant trouvé'**
  String get childSelectorNoChildrenTitle;

  /// No description provided for @childSelectorNoChildrenDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez actuellement aucun enfant ajouté.'**
  String get childSelectorNoChildrenDesc;

  /// No description provided for @otpVerifyTitlePrefix.
  ///
  /// In fr, this message translates to:
  /// **'VÉRIFIER'**
  String get otpVerifyTitlePrefix;

  /// No description provided for @otpSentToText.
  ///
  /// In fr, this message translates to:
  /// **'Nous avons envoyé un code au\n'**
  String get otpSentToText;

  /// No description provided for @otpPasteClipboard.
  ///
  /// In fr, this message translates to:
  /// **'COLLER DEPUIS LE PRESSE-PAPIERS'**
  String get otpPasteClipboard;

  /// No description provided for @otpErrorIncomplete.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez saisir les 6 chiffres'**
  String get otpErrorIncomplete;

  /// No description provided for @otpErrorFailed.
  ///
  /// In fr, this message translates to:
  /// **'La vérification a échoué'**
  String get otpErrorFailed;

  /// No description provided for @paymentErrorLaunch.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'ouvrir la page de paiement.'**
  String get paymentErrorLaunch;

  /// No description provided for @paymentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paiement'**
  String get paymentTitle;

  /// No description provided for @paymentPreparing.
  ///
  /// In fr, this message translates to:
  /// **'Préparation du paiement...'**
  String get paymentPreparing;

  /// No description provided for @paymentVerifying.
  ///
  /// In fr, this message translates to:
  /// **'Vérification du paiement...'**
  String get paymentVerifying;

  /// No description provided for @paymentSuccessTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paiement réussi !'**
  String get paymentSuccessTitle;

  /// No description provided for @paymentSuccessDesc.
  ///
  /// In fr, this message translates to:
  /// **'Votre réservation est confirmée.'**
  String get paymentSuccessDesc;

  /// No description provided for @paymentBackHome.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'accueil'**
  String get paymentBackHome;

  /// No description provided for @paymentFailedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Échec du paiement'**
  String get paymentFailedTitle;

  /// No description provided for @paymentTryAgain.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get paymentTryAgain;

  /// No description provided for @reservationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'MES RÉSERVATIONS'**
  String get reservationsTitle;

  /// No description provided for @reservationsUpcomingTab.
  ///
  /// In fr, this message translates to:
  /// **'À VENIR'**
  String get reservationsUpcomingTab;

  /// No description provided for @reservationsHistoryTab.
  ///
  /// In fr, this message translates to:
  /// **'HISTORIQUE'**
  String get reservationsHistoryTab;

  /// No description provided for @reservationsEmptyUpcomingTitle.
  ///
  /// In fr, this message translates to:
  /// **'AUCUNE RÉSERVATION À VENIR'**
  String get reservationsEmptyUpcomingTitle;

  /// No description provided for @reservationsEmptyUpcomingDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez pas encore de réservations à venir.'**
  String get reservationsEmptyUpcomingDesc;

  /// No description provided for @reservationsEmptyHistoryTitle.
  ///
  /// In fr, this message translates to:
  /// **'HISTORIQUE VIDE'**
  String get reservationsEmptyHistoryTitle;

  /// No description provided for @reservationsEmptyHistoryDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez pas encore de réservations passées.'**
  String get reservationsEmptyHistoryDesc;

  /// No description provided for @errorLoadingFailed.
  ///
  /// In fr, this message translates to:
  /// **'Chargement échoué'**
  String get errorLoadingFailed;

  /// No description provided for @actionRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get actionRetry;

  /// No description provided for @actionCancel.
  ///
  /// In fr, this message translates to:
  /// **'ANNULER'**
  String get actionCancel;

  /// No description provided for @actionVerify.
  ///
  /// In fr, this message translates to:
  /// **'VÉRIFIER'**
  String get actionVerify;

  /// No description provided for @actionPayNow.
  ///
  /// In fr, this message translates to:
  /// **'PAYER MAINTENANT'**
  String get actionPayNow;

  /// No description provided for @paymentErrorGeneric.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue.'**
  String get paymentErrorGeneric;

  /// No description provided for @paymentPointsTitle.
  ///
  /// In fr, this message translates to:
  /// **'PAYER AVEC DES POINTS'**
  String get paymentPointsTitle;

  /// No description provided for @paymentPointsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes sur le point de payer votre réservation avec vos points de fidélité. Cette action ne peut pas être annulée.'**
  String get paymentPointsDesc;

  /// No description provided for @paymentErrorMissingId.
  ///
  /// In fr, this message translates to:
  /// **'Identifiant de réservation manquant pour le paiement par fidélité.'**
  String get paymentErrorMissingId;

  /// No description provided for @paymentErrorInvalidId.
  ///
  /// In fr, this message translates to:
  /// **'Format de l\'identifiant de réservation invalide.'**
  String get paymentErrorInvalidId;

  /// No description provided for @paymentErrorNoUrl.
  ///
  /// In fr, this message translates to:
  /// **'Aucune URL de paiement reçue du serveur. Veuillez réessayer.'**
  String get paymentErrorNoUrl;

  /// No description provided for @paymentErrorUnconfirmed.
  ///
  /// In fr, this message translates to:
  /// **'Paiement non encore confirmé. Vous pouvez vérifier vos réservations.'**
  String get paymentErrorUnconfirmed;

  /// No description provided for @paymentCreatingReservation.
  ///
  /// In fr, this message translates to:
  /// **'Création de la réservation...'**
  String get paymentCreatingReservation;

  /// No description provided for @paymentOpeningGateway.
  ///
  /// In fr, this message translates to:
  /// **'Ouverture de la passerelle de paiement...'**
  String get paymentOpeningGateway;

  /// No description provided for @paymentViewBooking.
  ///
  /// In fr, this message translates to:
  /// **'VOIR MA RÉSERVATION'**
  String get paymentViewBooking;

  /// No description provided for @paymentDepositRequired.
  ///
  /// In fr, this message translates to:
  /// **'Acompte de 10% requis'**
  String get paymentDepositRequired;

  /// No description provided for @paymentMethodCardDesc.
  ///
  /// In fr, this message translates to:
  /// **'Cartes bancaires, E-Dinar, Portefeuilles'**
  String get paymentMethodCardDesc;

  /// No description provided for @paymentMethodPointsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Utilisez vos points de fidélité accumulés'**
  String get paymentMethodPointsDesc;

  /// No description provided for @serviceDetailPlans.
  ///
  /// In fr, this message translates to:
  /// **'Abonnements'**
  String get serviceDetailPlans;

  /// No description provided for @serviceDetailCourses.
  ///
  /// In fr, this message translates to:
  /// **'Cours'**
  String get serviceDetailCourses;

  /// No description provided for @serviceDetailEvents.
  ///
  /// In fr, this message translates to:
  /// **'Événements'**
  String get serviceDetailEvents;

  /// No description provided for @serviceDetailActivities.
  ///
  /// In fr, this message translates to:
  /// **'Activités'**
  String get serviceDetailActivities;

  /// No description provided for @serviceDetailErrorMsg.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get serviceDetailErrorMsg;

  /// No description provided for @serviceDetailRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get serviceDetailRetry;

  /// No description provided for @serviceDetailActive.
  ///
  /// In fr, this message translates to:
  /// **'Actif'**
  String get serviceDetailActive;

  /// No description provided for @serviceDetailAnnual.
  ///
  /// In fr, this message translates to:
  /// **'Annuel'**
  String get serviceDetailAnnual;

  /// No description provided for @serviceDetailYears.
  ///
  /// In fr, this message translates to:
  /// **'Années'**
  String get serviceDetailYears;

  /// No description provided for @serviceDetailMonthly.
  ///
  /// In fr, this message translates to:
  /// **'Mensuel'**
  String get serviceDetailMonthly;

  /// No description provided for @serviceDetailMonths.
  ///
  /// In fr, this message translates to:
  /// **'Mois'**
  String get serviceDetailMonths;

  /// No description provided for @serviceDetailDays.
  ///
  /// In fr, this message translates to:
  /// **'Jours'**
  String get serviceDetailDays;

  /// No description provided for @serviceDetailAllCourses.
  ///
  /// In fr, this message translates to:
  /// **'Tous les cours'**
  String get serviceDetailAllCourses;

  /// No description provided for @serviceDetailEventLabel.
  ///
  /// In fr, this message translates to:
  /// **'Événement'**
  String get serviceDetailEventLabel;

  /// No description provided for @servicesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Services'**
  String get servicesTitle;

  /// No description provided for @servicesSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher des services...'**
  String get servicesSearchHint;

  /// No description provided for @servicesFilterAll.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get servicesFilterAll;

  /// No description provided for @servicesFilterPlans.
  ///
  /// In fr, this message translates to:
  /// **'Abonnements'**
  String get servicesFilterPlans;

  /// No description provided for @servicesFilterCourses.
  ///
  /// In fr, this message translates to:
  /// **'Cours'**
  String get servicesFilterCourses;

  /// No description provided for @servicesFilterEvents.
  ///
  /// In fr, this message translates to:
  /// **'Événements'**
  String get servicesFilterEvents;

  /// No description provided for @servicesNoMatching.
  ///
  /// In fr, this message translates to:
  /// **'Aucun service correspondant'**
  String get servicesNoMatching;

  /// No description provided for @servicesNoAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucun service disponible'**
  String get servicesNoAvailable;

  /// No description provided for @servicesAdjustSearch.
  ///
  /// In fr, this message translates to:
  /// **'Essayez d\'ajuster votre recherche ou vos filtres.'**
  String get servicesAdjustSearch;

  /// No description provided for @servicesCheckBack.
  ///
  /// In fr, this message translates to:
  /// **'Revenez bientôt pour de nouveaux services.'**
  String get servicesCheckBack;

  /// No description provided for @notifGlobalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notifications Globales'**
  String get notifGlobalTitle;

  /// No description provided for @notifEnablePush.
  ///
  /// In fr, this message translates to:
  /// **'Activer les notifications push'**
  String get notifEnablePush;

  /// No description provided for @notifEnablePushSub.
  ///
  /// In fr, this message translates to:
  /// **'Bouton principal pour toutes les notifications'**
  String get notifEnablePushSub;

  /// No description provided for @notifPlanningTitle.
  ///
  /// In fr, this message translates to:
  /// **'Planning et Cours'**
  String get notifPlanningTitle;

  /// No description provided for @notifReservations.
  ///
  /// In fr, this message translates to:
  /// **'Réservations et Planning'**
  String get notifReservations;

  /// No description provided for @notifReservationsSub.
  ///
  /// In fr, this message translates to:
  /// **'Confirmations de réservation, rappels et annulations'**
  String get notifReservationsSub;

  /// No description provided for @notifCourses.
  ///
  /// In fr, this message translates to:
  /// **'Cours'**
  String get notifCourses;

  /// No description provided for @notifCoursesSub.
  ///
  /// In fr, this message translates to:
  /// **'Mises à jour de vos cours et instructeurs'**
  String get notifCoursesSub;

  /// No description provided for @notifAccountTitle.
  ///
  /// In fr, this message translates to:
  /// **'Compte et Paiements'**
  String get notifAccountTitle;

  /// No description provided for @notifSubscriptions.
  ///
  /// In fr, this message translates to:
  /// **'Abonnements'**
  String get notifSubscriptions;

  /// No description provided for @notifSubscriptionsSub.
  ///
  /// In fr, this message translates to:
  /// **'Avis de renouvellement et problèmes de paiement'**
  String get notifSubscriptionsSub;

  /// No description provided for @notifSecurity.
  ///
  /// In fr, this message translates to:
  /// **'Avertissements et Mises à jour de sécurité'**
  String get notifSecurity;

  /// No description provided for @notifSecuritySub.
  ///
  /// In fr, this message translates to:
  /// **'Mises à jour cruciales sur la sécurité du compte'**
  String get notifSecuritySub;

  /// No description provided for @notifCommunityTitle.
  ///
  /// In fr, this message translates to:
  /// **'Communauté et Offres'**
  String get notifCommunityTitle;

  /// No description provided for @notifFamily.
  ///
  /// In fr, this message translates to:
  /// **'Activité Familiale'**
  String get notifFamily;

  /// No description provided for @notifFamilySub.
  ///
  /// In fr, this message translates to:
  /// **'Activités et approbations des comptes enfants'**
  String get notifFamilySub;

  /// No description provided for @notifLoyalty.
  ///
  /// In fr, this message translates to:
  /// **'Fidélité et Points'**
  String get notifLoyalty;

  /// No description provided for @notifLoyaltySub.
  ///
  /// In fr, this message translates to:
  /// **'Récompenses gagnées et niveaux supérieurs'**
  String get notifLoyaltySub;

  /// No description provided for @notifPromo.
  ///
  /// In fr, this message translates to:
  /// **'Promotions et Offres'**
  String get notifPromo;

  /// No description provided for @notifPromoSub.
  ///
  /// In fr, this message translates to:
  /// **'Recevez des mises à jour sur les nouvelles offres'**
  String get notifPromoSub;

  /// No description provided for @paymentPayWithPointsTitle.
  ///
  /// In fr, this message translates to:
  /// **'PAYER AVEC DES POINTS'**
  String get paymentPayWithPointsTitle;

  /// No description provided for @paymentPayWithPointsWarning.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes sur le point de payer {price} TND avec vos points de fidélité. Cette action est irréversible.'**
  String paymentPayWithPointsWarning(String price);

  /// No description provided for @paymentPayNow.
  ///
  /// In fr, this message translates to:
  /// **'PAYER MAINTENANT'**
  String get paymentPayNow;

  /// No description provided for @paymentErrorCannotOpen.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'ouvrir la page de paiement.'**
  String get paymentErrorCannotOpen;

  /// No description provided for @paymentFailedRetry.
  ///
  /// In fr, this message translates to:
  /// **'Le paiement a échoué. Veuillez réessayer.'**
  String get paymentFailedRetry;

  /// No description provided for @paymentMethodTitle.
  ///
  /// In fr, this message translates to:
  /// **'MÉTHODE DE PAIEMENT'**
  String get paymentMethodTitle;

  /// No description provided for @paymentLoadingCreatingSub.
  ///
  /// In fr, this message translates to:
  /// **'Création de l\'abonnement...'**
  String get paymentLoadingCreatingSub;

  /// No description provided for @paymentLoadingPreparing.
  ///
  /// In fr, this message translates to:
  /// **'Préparation du paiement...'**
  String get paymentLoadingPreparing;

  /// No description provided for @paymentLoadingLoyalty.
  ///
  /// In fr, this message translates to:
  /// **'Traitement du paiement de fidélité...'**
  String get paymentLoadingLoyalty;

  /// No description provided for @paymentLoadingVerifying.
  ///
  /// In fr, this message translates to:
  /// **'Vérification du paiement...'**
  String get paymentLoadingVerifying;

  /// No description provided for @paymentSuccessChildDesc.
  ///
  /// In fr, this message translates to:
  /// **'L\'abonnement à {planName} est maintenant actif pour votre enfant.'**
  String paymentSuccessChildDesc(String planName);

  /// No description provided for @paymentBackToHome.
  ///
  /// In fr, this message translates to:
  /// **'RETOUR À L\'ACCUEIL'**
  String get paymentBackToHome;

  /// No description provided for @paymentUnknownError.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur inconnue s\'est produite.'**
  String get paymentUnknownError;

  /// No description provided for @paymentTotalAmount.
  ///
  /// In fr, this message translates to:
  /// **'MONTANT TOTAL'**
  String get paymentTotalAmount;

  /// No description provided for @paymentForPlan.
  ///
  /// In fr, this message translates to:
  /// **'Pour {planName}'**
  String paymentForPlan(String planName);

  /// No description provided for @paymentSelectMethod.
  ///
  /// In fr, this message translates to:
  /// **'SÉLECTIONNER LA MÉTHODE DE PAIEMENT'**
  String get paymentSelectMethod;

  /// No description provided for @paymentMethodKonnectTitle.
  ///
  /// In fr, this message translates to:
  /// **'Payer avec Konnect'**
  String get paymentMethodKonnectTitle;

  /// No description provided for @paymentMethodKonnectSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Cartes Bancaires, E-Dinar, Portefeuilles'**
  String get paymentMethodKonnectSubtitle;

  /// No description provided for @paymentOr.
  ///
  /// In fr, this message translates to:
  /// **'OU'**
  String get paymentOr;

  /// No description provided for @paymentMethodLoyaltyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Payer avec le Solde de Fidélité'**
  String get paymentMethodLoyaltyTitle;

  /// No description provided for @paymentMethodLoyaltySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Utilisez vos points accumulés'**
  String get paymentMethodLoyaltySubtitle;

  /// No description provided for @paymentSecurePaymentTitle.
  ///
  /// In fr, this message translates to:
  /// **'PAIEMENT SÉCURISÉ'**
  String get paymentSecurePaymentTitle;

  /// No description provided for @courseDetailBookedSession.
  ///
  /// In fr, this message translates to:
  /// **'Réservé {title} le {date} à {time}'**
  String courseDetailBookedSession(String title, String date, String time);

  /// No description provided for @subscriptionRequiredTitle.
  ///
  /// In fr, this message translates to:
  /// **'ABONNEMENT REQUIS'**
  String get subscriptionRequiredTitle;

  /// No description provided for @subscriptionRequiredBookMessage.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez besoin d\'un abonnement actif pour réserver des sessions. Abonnez-vous à un plan et réessayez.'**
  String get subscriptionRequiredBookMessage;

  /// No description provided for @subscriptionRequiredSignInMessage.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous et abonnez-vous à un plan pour réserver des sessions.'**
  String get subscriptionRequiredSignInMessage;

  /// No description provided for @closeButton.
  ///
  /// In fr, this message translates to:
  /// **'FERMER'**
  String get closeButton;

  /// No description provided for @viewPlansButton.
  ///
  /// In fr, this message translates to:
  /// **'VOIR LES PLANS'**
  String get viewPlansButton;

  /// No description provided for @signInButton.
  ///
  /// In fr, this message translates to:
  /// **'SE CONNECTER'**
  String get signInButton;

  /// No description provided for @monthJanuary.
  ///
  /// In fr, this message translates to:
  /// **'Janvier'**
  String get monthJanuary;

  /// No description provided for @monthFebruary.
  ///
  /// In fr, this message translates to:
  /// **'Février'**
  String get monthFebruary;

  /// No description provided for @monthMarch.
  ///
  /// In fr, this message translates to:
  /// **'Mars'**
  String get monthMarch;

  /// No description provided for @monthApril.
  ///
  /// In fr, this message translates to:
  /// **'Avril'**
  String get monthApril;

  /// No description provided for @monthMay.
  ///
  /// In fr, this message translates to:
  /// **'Mai'**
  String get monthMay;

  /// No description provided for @monthJune.
  ///
  /// In fr, this message translates to:
  /// **'Juin'**
  String get monthJune;

  /// No description provided for @monthJuly.
  ///
  /// In fr, this message translates to:
  /// **'Juillet'**
  String get monthJuly;

  /// No description provided for @monthAugust.
  ///
  /// In fr, this message translates to:
  /// **'Août'**
  String get monthAugust;

  /// No description provided for @monthSeptember.
  ///
  /// In fr, this message translates to:
  /// **'Septembre'**
  String get monthSeptember;

  /// No description provided for @monthOctober.
  ///
  /// In fr, this message translates to:
  /// **'Octobre'**
  String get monthOctober;

  /// No description provided for @monthNovember.
  ///
  /// In fr, this message translates to:
  /// **'Novembre'**
  String get monthNovember;

  /// No description provided for @monthDecember.
  ///
  /// In fr, this message translates to:
  /// **'Décembre'**
  String get monthDecember;

  /// No description provided for @reserveAction.
  ///
  /// In fr, this message translates to:
  /// **'RÉSERVER'**
  String get reserveAction;

  /// No description provided for @daySunday.
  ///
  /// In fr, this message translates to:
  /// **'Dimanche'**
  String get daySunday;

  /// No description provided for @dayMonday.
  ///
  /// In fr, this message translates to:
  /// **'Lundi'**
  String get dayMonday;

  /// No description provided for @dayTuesday.
  ///
  /// In fr, this message translates to:
  /// **'Mardi'**
  String get dayTuesday;

  /// No description provided for @dayWednesday.
  ///
  /// In fr, this message translates to:
  /// **'Mercredi'**
  String get dayWednesday;

  /// No description provided for @dayThursday.
  ///
  /// In fr, this message translates to:
  /// **'Jeudi'**
  String get dayThursday;

  /// No description provided for @dayFriday.
  ///
  /// In fr, this message translates to:
  /// **'Vendredi'**
  String get dayFriday;

  /// No description provided for @daySaturday.
  ///
  /// In fr, this message translates to:
  /// **'Samedi'**
  String get daySaturday;

  /// No description provided for @courseDefaultTitle.
  ///
  /// In fr, this message translates to:
  /// **'COURS'**
  String get courseDefaultTitle;

  /// No description provided for @upcomingSessionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'SESSIONS À VENIR'**
  String get upcomingSessionsTitle;

  /// No description provided for @noUpcomingSessionsMessage.
  ///
  /// In fr, this message translates to:
  /// **'Aucune session à venir cette semaine'**
  String get noUpcomingSessionsMessage;

  /// No description provided for @subscriptionRequiredViewBookMessage.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez besoin d\'un abonnement actif pour voir et réserver des sessions pour ce cours.'**
  String get subscriptionRequiredViewBookMessage;

  /// No description provided for @subscriptionRequiredSignInViewBookMessage.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous et abonnez-vous à un plan pour voir et réserver des sessions.'**
  String get subscriptionRequiredSignInViewBookMessage;

  /// No description provided for @statusBooked.
  ///
  /// In fr, this message translates to:
  /// **'RÉSERVÉ'**
  String get statusBooked;

  /// No description provided for @statusFull.
  ///
  /// In fr, this message translates to:
  /// **'COMPLET'**
  String get statusFull;

  /// No description provided for @remainingPlaces.
  ///
  /// In fr, this message translates to:
  /// **'{count} PLACES'**
  String remainingPlaces(String count);

  /// No description provided for @viewDetailsLabel.
  ///
  /// In fr, this message translates to:
  /// **'VOIR LES DÉTAILS'**
  String get viewDetailsLabel;

  /// No description provided for @signInRequiredTitle.
  ///
  /// In fr, this message translates to:
  /// **'Connexion requise'**
  String get signInRequiredTitle;

  /// No description provided for @signInRequiredMessage.
  ///
  /// In fr, this message translates to:
  /// **'Vous devez être connecté pour voir et réserver des cours. Rejoignez-nous pour commencer votre parcours de fitness !'**
  String get signInRequiredMessage;

  /// No description provided for @signInRegisterButton.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter / S\'inscrire'**
  String get signInRegisterButton;

  /// No description provided for @unlockPlanningTitle.
  ///
  /// In fr, this message translates to:
  /// **'Débloquer le planning'**
  String get unlockPlanningTitle;

  /// No description provided for @unlockPlanningMessage.
  ///
  /// In fr, this message translates to:
  /// **'Un abonnement actif est requis pour voir les horaires des cours et réserver des classes. Rejoignez-nous et élevez votre parcours de fitness !'**
  String get unlockPlanningMessage;

  /// No description provided for @viewPlansLabel.
  ///
  /// In fr, this message translates to:
  /// **'Voir les plans'**
  String get viewPlansLabel;

  /// No description provided for @planningErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'ERREUR DE PLANNING'**
  String get planningErrorTitle;

  /// No description provided for @planningErrorMessage.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de récupérer le programme des cours. Veuillez vérifier votre connexion.'**
  String get planningErrorMessage;

  /// No description provided for @retryAction.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retryAction;

  /// No description provided for @planningSignInTitle.
  ///
  /// In fr, this message translates to:
  /// **'CONNECTEZ-VOUS'**
  String get planningSignInTitle;

  /// No description provided for @planningSignInMessage.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour accéder à votre planning de cours et réserver vos séances.'**
  String get planningSignInMessage;

  /// No description provided for @planningNoSessionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'AUCUNE SÉANCE'**
  String get planningNoSessionsTitle;

  /// No description provided for @planningNoSessionsSubscriptionMessage.
  ///
  /// In fr, this message translates to:
  /// **'Aucune séance disponible avec votre abonnement actuel. Passez à un abonnement supérieur pour accéder à plus de cours.'**
  String get planningNoSessionsSubscriptionMessage;

  /// No description provided for @planningNoSessionsWeekMessage.
  ///
  /// In fr, this message translates to:
  /// **'Aucune séance à venir cette semaine. Revenez plus tard pour découvrir le programme.'**
  String get planningNoSessionsWeekMessage;

  /// No description provided for @meLabel.
  ///
  /// In fr, this message translates to:
  /// **'Moi'**
  String get meLabel;

  /// No description provided for @meMemberName.
  ///
  /// In fr, this message translates to:
  /// **'{name} (Moi)'**
  String meMemberName(String name);

  /// No description provided for @browseTabCourses.
  ///
  /// In fr, this message translates to:
  /// **'COURS'**
  String get browseTabCourses;

  /// No description provided for @browseTabActivities.
  ///
  /// In fr, this message translates to:
  /// **'ACTIVITÉS'**
  String get browseTabActivities;

  /// No description provided for @browseTabEvents.
  ///
  /// In fr, this message translates to:
  /// **'ÉVÉNEMENTS'**
  String get browseTabEvents;

  /// No description provided for @browseErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'ERREUR'**
  String get browseErrorTitle;

  /// No description provided for @browseErrorRetry.
  ///
  /// In fr, this message translates to:
  /// **'RÉESSAYER'**
  String get browseErrorRetry;

  /// No description provided for @browseEventFallback.
  ///
  /// In fr, this message translates to:
  /// **'ÉVÉNEMENT'**
  String get browseEventFallback;

  /// No description provided for @browseUnknownStatus.
  ///
  /// In fr, this message translates to:
  /// **'Inconnu'**
  String get browseUnknownStatus;

  /// No description provided for @profileSubscriptionSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Gérer votre forfait et accès premium'**
  String get profileSubscriptionSubtitle;

  /// No description provided for @profileNotificationsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Gérer vos alertes et rappels de cours'**
  String get profileNotificationsSubtitle;

  /// No description provided for @profileSettingsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Informations personnelles et sécurité'**
  String get profileSettingsSubtitle;

  /// No description provided for @editProfilePhotoTitle.
  ///
  /// In fr, this message translates to:
  /// **'PHOTO DE PROFIL'**
  String get editProfilePhotoTitle;

  /// No description provided for @editProfileTakePhoto.
  ///
  /// In fr, this message translates to:
  /// **'PRENDRE UNE PHOTO'**
  String get editProfileTakePhoto;

  /// No description provided for @editProfileChoosePhoto.
  ///
  /// In fr, this message translates to:
  /// **'CHOISIR UNE PHOTO'**
  String get editProfileChoosePhoto;

  /// No description provided for @editProfileDeletePhoto.
  ///
  /// In fr, this message translates to:
  /// **'SUPPRIMER LA PHOTO'**
  String get editProfileDeletePhoto;

  /// No description provided for @editProfilePhotoUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Photo de profil mise à jour'**
  String get editProfilePhotoUpdated;

  /// No description provided for @editProfilePhotoFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échec du téléchargement'**
  String get editProfilePhotoFailed;

  /// No description provided for @editProfileDeletePhotoConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment supprimer votre photo de profil ?'**
  String get editProfileDeletePhotoConfirm;

  /// No description provided for @commonDelete.
  ///
  /// In fr, this message translates to:
  /// **'SUPPRIMER'**
  String get commonDelete;

  /// No description provided for @editProfilePhotoDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Photo de profil supprimée'**
  String get editProfilePhotoDeleted;

  /// No description provided for @editProfilePhotoDeleteFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échec de la suppression'**
  String get editProfilePhotoDeleteFailed;

  /// No description provided for @editProfileOtpSendFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échec de l\'envoi du code à'**
  String get editProfileOtpSendFailed;

  /// No description provided for @editProfileVerifiedUpdated.
  ///
  /// In fr, this message translates to:
  /// **'vérifié et mis à jour avec succès !'**
  String get editProfileVerifiedUpdated;

  /// No description provided for @editProfileUpdateFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échec de la mise à jour de'**
  String get editProfileUpdateFailed;

  /// No description provided for @editProfileTabPersonal.
  ///
  /// In fr, this message translates to:
  /// **'PERSONNEL'**
  String get editProfileTabPersonal;

  /// No description provided for @editProfileTabSecurity.
  ///
  /// In fr, this message translates to:
  /// **'SÉCURITÉ'**
  String get editProfileTabSecurity;

  /// No description provided for @editProfileGender.
  ///
  /// In fr, this message translates to:
  /// **'GENRE'**
  String get editProfileGender;

  /// No description provided for @editProfileGenderHint.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner le genre'**
  String get editProfileGenderHint;

  /// No description provided for @editProfileGenderMale.
  ///
  /// In fr, this message translates to:
  /// **'Homme'**
  String get editProfileGenderMale;

  /// No description provided for @editProfileGenderFemale.
  ///
  /// In fr, this message translates to:
  /// **'Femme'**
  String get editProfileGenderFemale;

  /// No description provided for @commonVerify.
  ///
  /// In fr, this message translates to:
  /// **'VÉRIFIER'**
  String get commonVerify;

  /// No description provided for @editProfileSecurityNotice.
  ///
  /// In fr, this message translates to:
  /// **'Les modifications de votre e-mail ou numéro nécessitent une vérification par code OTP. Saisissez la nouvelle valeur et cliquez sur VÉRIFIER.'**
  String get editProfileSecurityNotice;

  /// No description provided for @editProfileEmailHint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre e-mail'**
  String get editProfileEmailHint;

  /// No description provided for @editProfilePhoneHint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre numéro de téléphone'**
  String get editProfilePhoneHint;

  /// No description provided for @planDetailChildOnlyPlan.
  ///
  /// In fr, this message translates to:
  /// **'Forfait Enfant Uniquement'**
  String get planDetailChildOnlyPlan;

  /// No description provided for @planDetailChildOnlyDesc.
  ///
  /// In fr, this message translates to:
  /// **'Ce forfait est conçu pour les enfants uniquement. Sélectionnez un enfant pour lui acheter ce forfait.'**
  String get planDetailChildOnlyDesc;

  /// No description provided for @planDetailSelectChild.
  ///
  /// In fr, this message translates to:
  /// **'SÉLECTIONNER UN ENFANT'**
  String get planDetailSelectChild;

  /// No description provided for @planDetailChildAdded.
  ///
  /// In fr, this message translates to:
  /// **'Enfant ajouté. Veuillez le sélectionner pour continuer.'**
  String get planDetailChildAdded;

  /// No description provided for @planDetailTitle.
  ///
  /// In fr, this message translates to:
  /// **'DÉTAILS DU FORFAIT'**
  String get planDetailTitle;

  /// No description provided for @planDetailIncludes.
  ///
  /// In fr, this message translates to:
  /// **'INCLUS'**
  String get planDetailIncludes;

  /// No description provided for @planDetailAccessAllCourses.
  ///
  /// In fr, this message translates to:
  /// **'Accès à TOUS les cours'**
  String get planDetailAccessAllCourses;

  /// No description provided for @planDetailSubscribeFor.
  ///
  /// In fr, this message translates to:
  /// **'S\'ABONNER POUR'**
  String get planDetailSubscribeFor;

  /// No description provided for @planDetailMyself.
  ///
  /// In fr, this message translates to:
  /// **'Moi-même'**
  String get planDetailMyself;

  /// No description provided for @planDetailChild.
  ///
  /// In fr, this message translates to:
  /// **'Enfant'**
  String get planDetailChild;

  /// No description provided for @planDetailActivePlan.
  ///
  /// In fr, this message translates to:
  /// **'FORFAIT ACTIF'**
  String get planDetailActivePlan;

  /// No description provided for @planDetailSubscribeBtn.
  ///
  /// In fr, this message translates to:
  /// **'S\'ABONNER'**
  String get planDetailSubscribeBtn;

  /// No description provided for @planDetailErrorSomethingWentWrong.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur s\'est produite'**
  String get planDetailErrorSomethingWentWrong;

  /// No description provided for @planDetailRetryBtn.
  ///
  /// In fr, this message translates to:
  /// **'RÉESSAYER'**
  String get planDetailRetryBtn;

  /// No description provided for @planDetailNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Forfait introuvable'**
  String get planDetailNotFound;

  /// No description provided for @planDetailArchived.
  ///
  /// In fr, this message translates to:
  /// **'Ce forfait a peut-être été archivé ou retiré.'**
  String get planDetailArchived;

  /// No description provided for @commonGoBack.
  ///
  /// In fr, this message translates to:
  /// **'RETOUR'**
  String get commonGoBack;

  /// No description provided for @eventsBracketRound.
  ///
  /// In fr, this message translates to:
  /// **'Tour'**
  String get eventsBracketRound;

  /// No description provided for @eventsBracketSemiFinals.
  ///
  /// In fr, this message translates to:
  /// **'Demi-finales'**
  String get eventsBracketSemiFinals;

  /// No description provided for @eventsBracketTBD.
  ///
  /// In fr, this message translates to:
  /// **'À déterminer'**
  String get eventsBracketTBD;

  /// No description provided for @eventsBracketTitle.
  ///
  /// In fr, this message translates to:
  /// **'Arbre du tournoi'**
  String get eventsBracketTitle;

  /// No description provided for @eventsBracketWalkover.
  ///
  /// In fr, this message translates to:
  /// **'Forfait'**
  String get eventsBracketWalkover;

  /// No description provided for @eventsDetailCheckedInStatus.
  ///
  /// In fr, this message translates to:
  /// **'Enregistré'**
  String get eventsDetailCheckedInStatus;

  /// No description provided for @eventsDetailCheckInAction.
  ///
  /// In fr, this message translates to:
  /// **'S\'enregistrer'**
  String get eventsDetailCheckInAction;

  /// No description provided for @eventsDetailCheckInRequired.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrement requis'**
  String get eventsDetailCheckInRequired;

  /// No description provided for @eventsDetailCheckInSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrement réussi'**
  String get eventsDetailCheckInSuccess;

  /// No description provided for @eventsDetailDateTBD.
  ///
  /// In fr, this message translates to:
  /// **'Date à déterminer'**
  String get eventsDetailDateTBD;

  /// No description provided for @eventsDetailErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Erreur'**
  String get eventsDetailErrorTitle;

  /// No description provided for @eventsDetailEventFallback.
  ///
  /// In fr, this message translates to:
  /// **'Événement'**
  String get eventsDetailEventFallback;

  /// No description provided for @eventsDetailFormat.
  ///
  /// In fr, this message translates to:
  /// **'Format'**
  String get eventsDetailFormat;

  /// No description provided for @eventsDetailNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Événement introuvable'**
  String get eventsDetailNotFound;

  /// No description provided for @eventsDetailParticipantsText.
  ///
  /// In fr, this message translates to:
  /// **'Participants'**
  String get eventsDetailParticipantsText;

  /// No description provided for @eventsDetailRegisterAction.
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire'**
  String get eventsDetailRegisterAction;

  /// No description provided for @eventsDetailRegisterBy.
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire avant le'**
  String get eventsDetailRegisterBy;

  /// No description provided for @eventsDetailRegisteredStatus.
  ///
  /// In fr, this message translates to:
  /// **'Inscrit'**
  String get eventsDetailRegisteredStatus;

  /// No description provided for @eventsDetailRegisterSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Inscription réussie'**
  String get eventsDetailRegisterSuccess;

  /// No description provided for @eventsDetailRegisterTitle.
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire à l\'événement'**
  String get eventsDetailRegisterTitle;

  /// No description provided for @eventsDetailRegistrationClosed.
  ///
  /// In fr, this message translates to:
  /// **'Inscriptions fermées'**
  String get eventsDetailRegistrationClosed;

  /// No description provided for @eventsDetailRetryButton.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get eventsDetailRetryButton;

  /// No description provided for @eventsDetailTBD.
  ///
  /// In fr, this message translates to:
  /// **'À déterminer'**
  String get eventsDetailTBD;

  /// No description provided for @eventsDetailThisEvent.
  ///
  /// In fr, this message translates to:
  /// **'cet événement'**
  String get eventsDetailThisEvent;

  /// No description provided for @eventsDetailViewBracketButton.
  ///
  /// In fr, this message translates to:
  /// **'Voir l\'arbre'**
  String get eventsDetailViewBracketButton;

  /// No description provided for @eventsDetailWaitlistSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Ajouté à la liste d\'attente'**
  String get eventsDetailWaitlistSuccess;

  /// No description provided for @eventsDetailWithdrawPromptPrefix.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment vous désinscrire de'**
  String get eventsDetailWithdrawPromptPrefix;

  /// No description provided for @eventsDetailWithdrawSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Désinscription réussie'**
  String get eventsDetailWithdrawSuccess;

  /// No description provided for @eventsDetailWithdrawTitle.
  ///
  /// In fr, this message translates to:
  /// **'Se désinscrire'**
  String get eventsDetailWithdrawTitle;

  /// No description provided for @eventsScreenCheckBackSoon.
  ///
  /// In fr, this message translates to:
  /// **'Revenez bientôt pour les prochains tournois'**
  String get eventsScreenCheckBackSoon;

  /// No description provided for @eventsScreenEventFallback.
  ///
  /// In fr, this message translates to:
  /// **'Événement'**
  String get eventsScreenEventFallback;

  /// No description provided for @eventsScreenNoTournaments.
  ///
  /// In fr, this message translates to:
  /// **'Aucun tournoi disponible'**
  String get eventsScreenNoTournaments;

  /// No description provided for @eventsScreenRetryButton.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get eventsScreenRetryButton;

  /// No description provided for @eventsScreenTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tournois'**
  String get eventsScreenTitle;

  /// No description provided for @myEventsScreenNoEvents.
  ///
  /// In fr, this message translates to:
  /// **'Aucun événement trouvé'**
  String get myEventsScreenNoEvents;

  /// No description provided for @myEventsScreenRetryButton.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get myEventsScreenRetryButton;

  /// No description provided for @myEventsScreenTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes événements'**
  String get myEventsScreenTitle;

  /// No description provided for @familyChildBookingsEmptyMessage.
  ///
  /// In fr, this message translates to:
  /// **'Aucune réservation trouvée.'**
  String get familyChildBookingsEmptyMessage;

  /// No description provided for @familyChildBookingsEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune réservation'**
  String get familyChildBookingsEmptyTitle;

  /// No description provided for @familyChildBookingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réservations'**
  String get familyChildBookingsTitle;

  /// No description provided for @familyChildCompletedAtPrefix.
  ///
  /// In fr, this message translates to:
  /// **'Terminé à :'**
  String get familyChildCompletedAtPrefix;

  /// No description provided for @familyChildCompletedEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune activité terminée'**
  String get familyChildCompletedEmptyTitle;

  /// No description provided for @familyChildCompletedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Terminé'**
  String get familyChildCompletedTitle;

  /// No description provided for @familyChildProfileDaysRemainingText.
  ///
  /// In fr, this message translates to:
  /// **'jours restants'**
  String get familyChildProfileDaysRemainingText;

  /// No description provided for @familyChildProfileEnd.
  ///
  /// In fr, this message translates to:
  /// **'Fin :'**
  String get familyChildProfileEnd;

  /// No description provided for @familyChildProfileErrorFallback.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur s\'est produite'**
  String get familyChildProfileErrorFallback;

  /// No description provided for @familyChildProfileRetryButton.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get familyChildProfileRetryButton;

  /// No description provided for @familyChildProfileScheduleButton.
  ///
  /// In fr, this message translates to:
  /// **'Calendrier'**
  String get familyChildProfileScheduleButton;

  /// No description provided for @familyChildProfileStart.
  ///
  /// In fr, this message translates to:
  /// **'Début :'**
  String get familyChildProfileStart;

  /// No description provided for @familyChildReservationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réservations'**
  String get familyChildReservationsTitle;

  /// No description provided for @familyChildScheduleEmptyMessage.
  ///
  /// In fr, this message translates to:
  /// **'Aucun cours ou activité dans cette plage de dates.'**
  String get familyChildScheduleEmptyMessage;

  /// No description provided for @familyChildScheduleEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun événement prévu'**
  String get familyChildScheduleEmptyTitle;

  /// No description provided for @familyChildScheduleFrom.
  ///
  /// In fr, this message translates to:
  /// **'DU'**
  String get familyChildScheduleFrom;

  /// No description provided for @familyChildScheduleTitle.
  ///
  /// In fr, this message translates to:
  /// **'CALENDRIER'**
  String get familyChildScheduleTitle;

  /// No description provided for @familyChildScheduleTo.
  ///
  /// In fr, this message translates to:
  /// **'AU'**
  String get familyChildScheduleTo;

  /// No description provided for @familyChildScheduleCompletedStatus.
  ///
  /// In fr, this message translates to:
  /// **'Terminé'**
  String get familyChildScheduleCompletedStatus;

  /// No description provided for @familyChildSessionsBookCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get familyChildSessionsBookCancel;

  /// No description provided for @familyChildSessionsBookDate.
  ///
  /// In fr, this message translates to:
  /// **'Date :'**
  String get familyChildSessionsBookDate;

  /// No description provided for @familyChildSessionsBookDay.
  ///
  /// In fr, this message translates to:
  /// **'Jour :'**
  String get familyChildSessionsBookDay;

  /// No description provided for @familyChildSessionsBookFull.
  ///
  /// In fr, this message translates to:
  /// **'La session est complète'**
  String get familyChildSessionsBookFull;

  /// No description provided for @familyChildSessionsBookSpots.
  ///
  /// In fr, this message translates to:
  /// **'Places :'**
  String get familyChildSessionsBookSpots;

  /// No description provided for @familyChildSessionsBookTime.
  ///
  /// In fr, this message translates to:
  /// **'Heure :'**
  String get familyChildSessionsBookTime;

  /// No description provided for @familyChildSessionsBookTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réserver une session'**
  String get familyChildSessionsBookTitle;

  /// No description provided for @familyChildSessionsEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune session disponible'**
  String get familyChildSessionsEmptyTitle;

  /// No description provided for @familyChildSessionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'SESSIONS DISPONIBLES'**
  String get familyChildSessionsTitle;

  /// No description provided for @familyChildSessionsBookSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Réservation réussie !'**
  String get familyChildSessionsBookSuccess;

  /// No description provided for @familyChildSessionsBookFailure.
  ///
  /// In fr, this message translates to:
  /// **'Échec de la réservation'**
  String get familyChildSessionsBookFailure;

  /// No description provided for @familyChildSessionsBookConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer la réservation'**
  String get familyChildSessionsBookConfirm;

  /// No description provided for @familyChildSessionsStatusBooked.
  ///
  /// In fr, this message translates to:
  /// **'Réservé'**
  String get familyChildSessionsStatusBooked;

  /// No description provided for @familyChildSessionsStatusFull.
  ///
  /// In fr, this message translates to:
  /// **'COMPLET'**
  String get familyChildSessionsStatusFull;

  /// No description provided for @familyChildSessionsBookTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Réserver la session'**
  String get familyChildSessionsBookTooltip;

  /// No description provided for @familyChildSubscriptionsDaysRemaining.
  ///
  /// In fr, this message translates to:
  /// **'jours restants'**
  String get familyChildSubscriptionsDaysRemaining;

  /// No description provided for @familyChildSubscriptionsEnd.
  ///
  /// In fr, this message translates to:
  /// **'Fin :'**
  String get familyChildSubscriptionsEnd;

  /// No description provided for @familyChildSubscriptionsStart.
  ///
  /// In fr, this message translates to:
  /// **'Début :'**
  String get familyChildSubscriptionsStart;

  /// No description provided for @familyChildSubscriptionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'ABONNEMENTS'**
  String get familyChildSubscriptionsTitle;

  /// No description provided for @familyChildSubscriptionsBuyNew.
  ///
  /// In fr, this message translates to:
  /// **'ACHETER UN NOUVEL ABONNEMENT'**
  String get familyChildSubscriptionsBuyNew;

  /// No description provided for @familyChildSubscriptionsEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun abonnement'**
  String get familyChildSubscriptionsEmptyTitle;

  /// No description provided for @familyChildSubscriptionsEmptyMessage.
  ///
  /// In fr, this message translates to:
  /// **'Achetez un abonnement pour commencer.'**
  String get familyChildSubscriptionsEmptyMessage;

  /// No description provided for @homeAvailable.
  ///
  /// In fr, this message translates to:
  /// **'disponible(s)'**
  String get homeAvailable;

  /// No description provided for @homeCoursesTitle.
  ///
  /// In fr, this message translates to:
  /// **'COURS'**
  String get homeCoursesTitle;

  /// No description provided for @homeEventsTitle.
  ///
  /// In fr, this message translates to:
  /// **'TOURNOIS ET ÉVÉNEMENTS'**
  String get homeEventsTitle;

  /// No description provided for @homeExploreButton.
  ///
  /// In fr, this message translates to:
  /// **'EXPLORER'**
  String get homeExploreButton;

  /// No description provided for @homeGlobalSearchTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Recherche globale'**
  String get homeGlobalSearchTooltip;

  /// No description provided for @homeNo.
  ///
  /// In fr, this message translates to:
  /// **'Aucun'**
  String get homeNo;

  /// No description provided for @homeRetryButton.
  ///
  /// In fr, this message translates to:
  /// **'RÉESSAYER'**
  String get homeRetryButton;

  /// No description provided for @homeSeeAllButton.
  ///
  /// In fr, this message translates to:
  /// **'VOIR TOUT'**
  String get homeSeeAllButton;

  /// No description provided for @homeServiceCourses.
  ///
  /// In fr, this message translates to:
  /// **'cours'**
  String get homeServiceCourses;

  /// No description provided for @homeServiceEvents.
  ///
  /// In fr, this message translates to:
  /// **'événements'**
  String get homeServiceEvents;

  /// No description provided for @homeServicePlans.
  ///
  /// In fr, this message translates to:
  /// **'plans'**
  String get homeServicePlans;

  /// No description provided for @homeServicesEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun service disponible'**
  String get homeServicesEmpty;

  /// No description provided for @homeServicesTitle.
  ///
  /// In fr, this message translates to:
  /// **'NOS SERVICES'**
  String get homeServicesTitle;

  /// No description provided for @homeActivityExploreButton.
  ///
  /// In fr, this message translates to:
  /// **'EXPLORER'**
  String get homeActivityExploreButton;

  /// No description provided for @loyaltyLoadFailedMessage.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger vos points.'**
  String get loyaltyLoadFailedMessage;

  /// No description provided for @loyaltyLoadFailedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Chargement échoué'**
  String get loyaltyLoadFailedTitle;

  /// No description provided for @loyaltyMaxTierReached.
  ///
  /// In fr, this message translates to:
  /// **'Niveau maximum atteint'**
  String get loyaltyMaxTierReached;

  /// No description provided for @loyaltyMyPointsTitle.
  ///
  /// In fr, this message translates to:
  /// **'MES POINTS'**
  String get loyaltyMyPointsTitle;

  /// No description provided for @loyaltyNextTier.
  ///
  /// In fr, this message translates to:
  /// **'Prochain palier'**
  String get loyaltyNextTier;

  /// No description provided for @loyaltyNoTransactionMessage.
  ///
  /// In fr, this message translates to:
  /// **'Vos transactions de points apparaîtront ici.'**
  String get loyaltyNoTransactionMessage;

  /// No description provided for @loyaltyNoTransactionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune transaction'**
  String get loyaltyNoTransactionTitle;

  /// No description provided for @loyaltyPointsBalance.
  ///
  /// In fr, this message translates to:
  /// **'SOLDE DE POINTS'**
  String get loyaltyPointsBalance;

  /// No description provided for @loyaltyPointsHistoryTitle.
  ///
  /// In fr, this message translates to:
  /// **'HISTORIQUE DES POINTS'**
  String get loyaltyPointsHistoryTitle;

  /// No description provided for @loyaltyPts.
  ///
  /// In fr, this message translates to:
  /// **'pts'**
  String get loyaltyPts;

  /// No description provided for @loyaltyRetryButton.
  ///
  /// In fr, this message translates to:
  /// **'RÉESSAYER'**
  String get loyaltyRetryButton;

  /// No description provided for @loyaltySourceDailyCheckin.
  ///
  /// In fr, this message translates to:
  /// **'Check-in quotidien'**
  String get loyaltySourceDailyCheckin;

  /// No description provided for @loyaltySourceReferral.
  ///
  /// In fr, this message translates to:
  /// **'Parrainage'**
  String get loyaltySourceReferral;

  /// No description provided for @loyaltySourceSubscriptionRenewal.
  ///
  /// In fr, this message translates to:
  /// **'Renouvellement d\'abonnement'**
  String get loyaltySourceSubscriptionRenewal;

  /// No description provided for @loyaltySourceReservationCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Réservation complétée'**
  String get loyaltySourceReservationCompleted;

  /// No description provided for @loyaltySourceWelcomeBonus.
  ///
  /// In fr, this message translates to:
  /// **'Bonus de bienvenue'**
  String get loyaltySourceWelcomeBonus;

  /// No description provided for @loyaltySourceTransaction.
  ///
  /// In fr, this message translates to:
  /// **'Transaction'**
  String get loyaltySourceTransaction;

  /// No description provided for @notificationFilterAll.
  ///
  /// In fr, this message translates to:
  /// **'TOUT'**
  String get notificationFilterAll;

  /// No description provided for @notificationFilterUnread.
  ///
  /// In fr, this message translates to:
  /// **'NON LUS'**
  String get notificationFilterUnread;

  /// No description provided for @notificationFilterReservations.
  ///
  /// In fr, this message translates to:
  /// **'RÉSERVATIONS'**
  String get notificationFilterReservations;

  /// No description provided for @notificationFilterSubscriptions.
  ///
  /// In fr, this message translates to:
  /// **'ABONNEMENTS'**
  String get notificationFilterSubscriptions;

  /// No description provided for @notificationFilterLoyalty.
  ///
  /// In fr, this message translates to:
  /// **'LOYALITÉ'**
  String get notificationFilterLoyalty;

  /// No description provided for @notificationFilterOffers.
  ///
  /// In fr, this message translates to:
  /// **'OFFRES'**
  String get notificationFilterOffers;

  /// No description provided for @notificationFilterFamily.
  ///
  /// In fr, this message translates to:
  /// **'FAMILLE'**
  String get notificationFilterFamily;

  /// No description provided for @notificationCaughtUpMessage.
  ///
  /// In fr, this message translates to:
  /// **'VOUS ÊTES À JOUR'**
  String get notificationCaughtUpMessage;

  /// No description provided for @notificationEmptyFilterMessage.
  ///
  /// In fr, this message translates to:
  /// **'Aucune notification ne correspond à ce filtre.'**
  String get notificationEmptyFilterMessage;

  /// No description provided for @notificationEmptyFilterTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat'**
  String get notificationEmptyFilterTitle;

  /// No description provided for @notificationEmptyMessage.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez aucune notification pour le moment.'**
  String get notificationEmptyMessage;

  /// No description provided for @notificationEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune notification'**
  String get notificationEmptyTitle;

  /// No description provided for @notificationLoadFailedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Chargement échoué'**
  String get notificationLoadFailedTitle;

  /// No description provided for @notificationMarkAllReadTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Tout marquer comme lu'**
  String get notificationMarkAllReadTooltip;

  /// No description provided for @notificationRetryButton.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get notificationRetryButton;

  /// No description provided for @notificationScreenTitle.
  ///
  /// In fr, this message translates to:
  /// **'NOTIFICATIONS'**
  String get notificationScreenTitle;

  /// No description provided for @familyChildProfileActiveSubscription.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement actif'**
  String get familyChildProfileActiveSubscription;

  /// No description provided for @familyChildProfileSubscriptionsButton.
  ///
  /// In fr, this message translates to:
  /// **'Abonnements'**
  String get familyChildProfileSubscriptionsButton;

  /// No description provided for @familyChildProfileBookingsButton.
  ///
  /// In fr, this message translates to:
  /// **'Réservations'**
  String get familyChildProfileBookingsButton;

  /// No description provided for @familyChildProfileSessionsButton.
  ///
  /// In fr, this message translates to:
  /// **'Sessions'**
  String get familyChildProfileSessionsButton;

  /// No description provided for @familyChildProfileReservationsButton.
  ///
  /// In fr, this message translates to:
  /// **'Réservations'**
  String get familyChildProfileReservationsButton;

  /// No description provided for @familyChildProfileCompletedButton.
  ///
  /// In fr, this message translates to:
  /// **'Terminées'**
  String get familyChildProfileCompletedButton;

  /// No description provided for @familyChildBookingCompletedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Marqué comme terminé'**
  String get familyChildBookingCompletedSuccess;

  /// No description provided for @familyChildBookingCompletedFailure.
  ///
  /// In fr, this message translates to:
  /// **'Échec de l\'achèvement'**
  String get familyChildBookingCompletedFailure;

  /// No description provided for @familyChildBookingsCompletedStatus.
  ///
  /// In fr, this message translates to:
  /// **'Terminé'**
  String get familyChildBookingsCompletedStatus;

  /// No description provided for @familyChildBookingsMarkCompletedTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Marquer comme terminé'**
  String get familyChildBookingsMarkCompletedTooltip;

  /// No description provided for @familyChildReservationsEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune réservation'**
  String get familyChildReservationsEmptyTitle;

  /// No description provided for @familyChildReservationsEmptyMessage.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez aucune réservation.'**
  String get familyChildReservationsEmptyMessage;

  /// No description provided for @familyChildReservationsShowQrTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Afficher le QR code'**
  String get familyChildReservationsShowQrTooltip;

  /// No description provided for @familyChildReservationsCloseButton.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get familyChildReservationsCloseButton;

  /// No description provided for @familyChildCompletedEmptyMessage.
  ///
  /// In fr, this message translates to:
  /// **'Aucun élément terminé.'**
  String get familyChildCompletedEmptyMessage;

  /// No description provided for @familyChildCompletedStatus.
  ///
  /// In fr, this message translates to:
  /// **'Terminé'**
  String get familyChildCompletedStatus;

  /// No description provided for @eventsScreenWaitlistSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Ajouté à la liste d\'attente'**
  String get eventsScreenWaitlistSuccess;

  /// No description provided for @eventsScreenRegisterSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Inscription réussie'**
  String get eventsScreenRegisterSuccess;

  /// No description provided for @eventsScreenViewDetailsButton.
  ///
  /// In fr, this message translates to:
  /// **'Voir les détails'**
  String get eventsScreenViewDetailsButton;

  /// No description provided for @eventsScreenRegisterButton.
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire'**
  String get eventsScreenRegisterButton;

  /// No description provided for @eventsBracketRetryButton.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get eventsBracketRetryButton;

  /// No description provided for @eventsBracketNotAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Arbre non disponible'**
  String get eventsBracketNotAvailable;

  /// No description provided for @eventsBracketFinal.
  ///
  /// In fr, this message translates to:
  /// **'Finale'**
  String get eventsBracketFinal;

  /// No description provided for @eventsBracketQuarterFinals.
  ///
  /// In fr, this message translates to:
  /// **'Quarts de finale'**
  String get eventsBracketQuarterFinals;

  /// No description provided for @eventsBracketCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Terminé'**
  String get eventsBracketCompleted;

  /// No description provided for @myEventsStatusRegistered.
  ///
  /// In fr, this message translates to:
  /// **'INSCRIT'**
  String get myEventsStatusRegistered;

  /// No description provided for @myEventsStatusApproved.
  ///
  /// In fr, this message translates to:
  /// **'APPROUVÉ'**
  String get myEventsStatusApproved;

  /// No description provided for @myEventsStatusPending.
  ///
  /// In fr, this message translates to:
  /// **'EN ATTENTE'**
  String get myEventsStatusPending;

  /// No description provided for @myEventsStatusWithdrawn.
  ///
  /// In fr, this message translates to:
  /// **'RETIRÉ'**
  String get myEventsStatusWithdrawn;

  /// No description provided for @myEventsStatusWaitlisted.
  ///
  /// In fr, this message translates to:
  /// **'LISTE D\'ATTENTE'**
  String get myEventsStatusWaitlisted;

  /// No description provided for @myEventsEventUpcoming.
  ///
  /// In fr, this message translates to:
  /// **'À VENIR'**
  String get myEventsEventUpcoming;

  /// No description provided for @myEventsEventInProgress.
  ///
  /// In fr, this message translates to:
  /// **'EN COURS'**
  String get myEventsEventInProgress;

  /// No description provided for @myEventsEventCompleted.
  ///
  /// In fr, this message translates to:
  /// **'TERMINÉ'**
  String get myEventsEventCompleted;

  /// No description provided for @paymentExternalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Passerelle sécurisée ouverte'**
  String get paymentExternalTitle;

  /// No description provided for @paymentExternalDesc.
  ///
  /// In fr, this message translates to:
  /// **'Nous avons ouvert la passerelle de paiement dans votre navigateur. Veuillez y effectuer la transaction.'**
  String get paymentExternalDesc;

  /// No description provided for @paymentOpenAgain.
  ///
  /// In fr, this message translates to:
  /// **'ROUVRIR LA PAGE DE PAIEMENT'**
  String get paymentOpenAgain;

  /// No description provided for @paymentDoneConfirm.
  ///
  /// In fr, this message translates to:
  /// **'J\'AI EFFECTUÉ LE PAIEMENT'**
  String get paymentDoneConfirm;

  /// No description provided for @paymentCancel.
  ///
  /// In fr, this message translates to:
  /// **'ANNULER'**
  String get paymentCancel;
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
