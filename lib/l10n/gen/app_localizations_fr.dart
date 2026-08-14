// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Smart Cityzen';

  @override
  String get appTagline =>
      'Votre passerelle numérique vers les services civiques';

  @override
  String get welcomeBack => 'Content de vous revoir,';

  @override
  String get tapCardToFlip => 'Touchez la carte pour la retourner';

  @override
  String get myCity => 'Ma Ville';

  @override
  String get cityInformation => 'Informations';

  @override
  String get cityNews => 'Actualités';

  @override
  String get cityHistory => 'Histoire';

  @override
  String get capitalCity => 'Ville Capitale';

  @override
  String get timezoneLabel => 'Fuseau Horaire';

  @override
  String get stateLabel => 'État';

  @override
  String get aboutThisCity => 'À Propos de Cette Ville';

  @override
  String get latestUpdates => 'Dernières Mises à Jour';

  @override
  String get placeholderContentNotice =>
      'Contenu d\'exemple — mises à jour en direct bientôt disponibles';

  @override
  String get heritageTimeline => 'Chronologie du Patrimoine';

  @override
  String get noCityAssigned =>
      'Aucune ville n\'est encore associée à votre compte';

  @override
  String get active => 'Actif';

  @override
  String validTill(String date) {
    return 'Valable jusqu\'au $date';
  }

  @override
  String get verifiedMember => 'Membre Vérifié';

  @override
  String get exploreCityServices => 'Explorer les Services de la Ville';

  @override
  String get scanQrToCheckIn => 'Scanner le QR pour Pointer';

  @override
  String get pointCameraAtQr =>
      'Pointez votre caméra vers un code QR d\'enregistrement de salle';

  @override
  String get checkInSuccessful => 'Enregistrement Réussi';

  @override
  String get cameraPermissionDenied =>
      'L\'accès à la caméra est requis pour scanner le code QR d\'enregistrement';

  @override
  String get invalidQrCode =>
      'Ce code QR n\'est pas un code d\'enregistrement de salle valide';

  @override
  String get checkingIn => 'Enregistrement en cours…';

  @override
  String get scanAnyQr => 'Scanner un QR';

  @override
  String get checkInQrSubtitle =>
      'Scannez le QR d\'enregistrement de votre adhésion';

  @override
  String get uploadQr => 'Importer un QR';

  @override
  String get torch => 'Torche';

  @override
  String get oneAppTitle => 'Une App. Tous les Besoins de votre Ville.';

  @override
  String get oneAppSubtitle =>
      'Accédez, connectez et simplifiez votre vie en ville.';

  @override
  String get exploreNow => 'Explorer Maintenant';

  @override
  String get faqs => 'FAQ';

  @override
  String get privacyPolicy => 'Politique de Confidentialité';

  @override
  String get contactUs => 'Nous Contacter';

  @override
  String get feedback => 'Retour d\'expérience';

  @override
  String get login => 'Connexion';

  @override
  String get register => 'S\'inscrire';

  @override
  String get emailAddress => 'Adresse e-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get fullName => 'Nom complet';

  @override
  String get mobileNumber => 'Numéro de mobile';

  @override
  String get selectYourCity => 'Sélectionnez votre ville';

  @override
  String get createPassword => 'Créer un mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get accessPortal => 'Accéder au portail';

  @override
  String get createIdentity => 'Créer une identité';

  @override
  String get orContinueWith => 'Ou continuer avec';

  @override
  String get continueWithGoogle => 'Google';

  @override
  String get continueWithFacebook => 'Facebook';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';

  @override
  String get sendResetCode => 'Envoyer le code';

  @override
  String get resetCode => 'Code de réinitialisation';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get backToLogin => 'Retour à la connexion';

  @override
  String get home => 'Accueil';

  @override
  String get services => 'Services';

  @override
  String get id => 'ID';

  @override
  String get profile => 'Profil';

  @override
  String get cityzenIdentity => 'Identité Cityzen';

  @override
  String get searchServicesHint => 'Rechercher services, IDs...';

  @override
  String get cityServices => 'Services de la ville';

  @override
  String get viewAll => 'Tout voir';

  @override
  String get myMemberships => 'Mes adhésions';

  @override
  String get manage => 'Gérer';

  @override
  String get viewDetails => 'Voir les détails';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get libraries => 'Bibliothèques';

  @override
  String get gyms => 'Salles de sport';

  @override
  String get hospitals => 'Hôpitaux';

  @override
  String get yoga => 'Yoga';

  @override
  String get dance => 'Danse';

  @override
  String get coaching => 'Coaching';

  @override
  String get photos => 'Photos';

  @override
  String get more => 'Plus';

  @override
  String get searchFacilitiesHint => 'Rechercher bibliothèques, salles...';

  @override
  String get openNow => 'Ouvert maintenant';

  @override
  String get nearMe => 'Près de moi';

  @override
  String get freeWifi => 'WiFi gratuit';

  @override
  String get filters => 'Filtres';

  @override
  String get closed => 'Fermé';

  @override
  String get available => 'Disponible';

  @override
  String get limitedSpace => 'Espace limité';

  @override
  String kmAway(String distance) {
    return 'À $distance km';
  }

  @override
  String openUntil(String time) {
    return 'Jusqu\'à $time';
  }

  @override
  String get about => 'À propos';

  @override
  String get amenities => 'Équipements';

  @override
  String get hours => 'Horaires';

  @override
  String get location => 'Emplacement';

  @override
  String get directions => 'Itinéraire';

  @override
  String get call => 'Appeler';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get membershipDetails => 'Détails de l\'adhésion';

  @override
  String get validityStatus => 'Statut de validité';

  @override
  String validUntil(String date) {
    return 'Valide jusqu\'au $date';
  }

  @override
  String get quickCheckIn => 'Enregistrement rapide';

  @override
  String get checkOut => 'Enregistrer la sortie';

  @override
  String get details => 'Détails';

  @override
  String get attendance => 'Présence';

  @override
  String get payments => 'Paiements';

  @override
  String get memberInformation => 'Informations du membre';

  @override
  String get memberId => 'ID membre';

  @override
  String get tier => 'Niveau';

  @override
  String get facilityAccess => 'Accès aux installations';

  @override
  String joined(String date) {
    return 'Inscrit le $date';
  }

  @override
  String get contactStaffToJoin =>
      'Contactez le personnel pour rejoindre cette installation';

  @override
  String get contactStaffToRenew =>
      'Contactez le personnel pour renouveler votre adhésion';

  @override
  String get contactStaffBody =>
      'L\'inscription en libre-service n\'est pas encore disponible. Contactez directement l\'installation et notre personnel configurera votre adhésion.';

  @override
  String get sendEmail => 'Envoyer un e-mail';

  @override
  String get callFacility => 'Appeler l\'installation';

  @override
  String get myPayments => 'Mes paiements';

  @override
  String get paymentReceipt => 'Reçu de paiement';

  @override
  String get amount => 'Montant';

  @override
  String get status => 'Statut';

  @override
  String get paymentMethod => 'Méthode de paiement';

  @override
  String get transactionReference => 'Référence de transaction';

  @override
  String get invoiceNumber => 'Numéro de facture';

  @override
  String get dueDate => 'Date d\'échéance';

  @override
  String get paidOn => 'Payé le';

  @override
  String get notes => 'Notes';

  @override
  String get invoiceEmailedNotice =>
      'Une facture PDF détaillée vous a été envoyée par e-mail lors de l\'enregistrement de ce paiement.';

  @override
  String get myProfile => 'Mon profil';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get saveChanges => 'Enregistrer';

  @override
  String get role => 'Rôle';

  @override
  String get accountStatus => 'Statut du compte';

  @override
  String get security => 'Sécurité';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get loginHistory => 'Historique de connexion';

  @override
  String get logout => 'Déconnexion';

  @override
  String get logoutAllDevices => 'Déconnexion de tous les appareils';

  @override
  String get suspiciousLogin => 'Suspect';

  @override
  String get device => 'Appareil';

  @override
  String get ipAddress => 'Adresse IP';

  @override
  String get browser => 'Navigateur';

  @override
  String get retry => 'Réessayer';

  @override
  String get somethingWentWrong => 'Une erreur s\'est produite';

  @override
  String get noInternetConnection => 'Pas de connexion internet';

  @override
  String get noResultsFound => 'Aucun résultat trouvé';

  @override
  String get noMembershipsYet => 'Vous n\'avez pas encore d\'adhésion';

  @override
  String get noPaymentsYet => 'Aucun historique de paiement';

  @override
  String get noLoginHistoryYet => 'Aucun historique de connexion';

  @override
  String get noExceptionsYet => 'Aucune remise ni exception active';

  @override
  String get pullToRefresh => 'Tirez pour actualiser';

  @override
  String get requiredField => 'Ce champ est obligatoire';

  @override
  String get invalidEmail => 'Entrez une adresse e-mail valide';

  @override
  String get passwordTooShort =>
      'Le mot de passe doit comporter au moins 8 caractères';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get invalidPhone => 'Entrez un numéro de téléphone valide';

  @override
  String get errorValidation => 'Veuillez vérifier les informations saisies';

  @override
  String get errorAuthentication => 'E-mail ou mot de passe incorrect';

  @override
  String get errorAuthorization =>
      'Vous n\'avez pas la permission de faire cela';

  @override
  String get errorAccountBlocked =>
      'Votre compte a été bloqué. Contactez le support.';

  @override
  String get errorAccountInactive =>
      'Votre compte est inactif. Contactez le support.';

  @override
  String get errorNotFound => 'Nous n\'avons pas trouvé cela';

  @override
  String get errorConflict =>
      'Cette action entre en conflit avec l\'état actuel';

  @override
  String errorRateLimited(int seconds) {
    return 'Trop de tentatives. Réessayez dans ${seconds}s';
  }

  @override
  String get errorServer => 'Erreur serveur. Veuillez réessayer bientôt';

  @override
  String get errorGeneric => 'Erreur inattendue. Veuillez réessayer';

  @override
  String get settings => 'Paramètres';

  @override
  String get networkSettings => 'Réseau';

  @override
  String get apiBaseUrl => 'URL de base de l\'API';

  @override
  String get apiBaseUrlHint => 'https://api.example.com/api/v1';

  @override
  String get invalidUrl => 'Entrez une URL valide';

  @override
  String get connectTimeout => 'Délai de connexion';

  @override
  String get receiveTimeout => 'Délai de réception';

  @override
  String timeoutSeconds(int seconds) {
    return '$seconds secondes';
  }

  @override
  String get requestLogging => 'Journalisation des requêtes';

  @override
  String get requestLoggingSubtitle =>
      'Journaliser les requêtes réseau pour le débogage';

  @override
  String get testConnection => 'Tester la connexion';

  @override
  String get connectionSuccessful => 'Connexion réussie';

  @override
  String get connectionFailed => 'Échec de la connexion';

  @override
  String get saveAnyway => 'Enregistrer quand même';

  @override
  String get resetToDefaults => 'Réinitialiser par défaut';

  @override
  String get settingsSaved => 'Paramètres enregistrés';

  @override
  String get confirmResetSettings =>
      'Cela restaurera l\'URL de l\'API et les délais par défaut. Continuer ?';

  @override
  String get appearance => 'Apparence';

  @override
  String get theme => 'Thème';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeSystemSubtitle => 'Correspond au réglage de votre appareil';

  @override
  String get themeLightSubtitle => 'Toujours utiliser le thème clair';

  @override
  String get themeDarkSubtitle => 'Toujours utiliser le thème sombre';
}
