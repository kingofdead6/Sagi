// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Saji';

  @override
  String get welcomeTitle => 'Bienvenue sur Saji';

  @override
  String get welcomeSubtitle => 'Tout ce qu\'il vous faut, livré chez vous';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonConfirm => 'Confirmer';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonEdit => 'Modifier';

  @override
  String get commonAdd => 'Ajouter';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonSearch => 'Rechercher';

  @override
  String get commonNext => 'Suivant';

  @override
  String get commonBack => 'Retour';

  @override
  String get commonSeeAll => 'Voir tout';

  @override
  String get commonYes => 'Oui';

  @override
  String get commonNo => 'Non';

  @override
  String get commonLoading => 'Chargement…';

  @override
  String get commonOptional => 'Facultatif';

  @override
  String get commonRequired => 'Obligatoire';

  @override
  String get commonCall => 'Appeler';

  @override
  String get commonFilter => 'Filtrer';

  @override
  String get commonApply => 'Appliquer';

  @override
  String get commonReset => 'Réinitialiser';

  @override
  String get commonToday => 'Aujourd\'hui';

  @override
  String get commonNone => 'Aucun';

  @override
  String get commonRefresh => 'Actualiser';

  @override
  String get commonExport => 'Exporter';

  @override
  String get errorGeneric => 'Une erreur est survenue, veuillez réessayer';

  @override
  String get errorNetwork => 'Pas de connexion Internet, vérifiez votre réseau';

  @override
  String get errorTimeout => 'La requête a pris trop de temps, réessayez';

  @override
  String get errorServer =>
      'Le serveur ne répond pas, réessayez dans un instant';

  @override
  String get errorUnauthorized => 'Votre session a expiré, reconnectez-vous';

  @override
  String get errorForbidden =>
      'Vous n\'avez pas la permission pour cette action';

  @override
  String get errorNotFound => 'Élément introuvable';

  @override
  String get errorConflict => 'Cette action est impossible pour le moment';

  @override
  String get errorValidation => 'Vérifiez les informations saisies';

  @override
  String get errorTooMany => 'Trop de tentatives, patientez un instant';

  @override
  String get authLoginTitle => 'Connexion';

  @override
  String get authRegisterTitle => 'Créer un compte';

  @override
  String get authPhone => 'Numéro de téléphone';

  @override
  String get authPhoneHint => '0X XX XX XX XX';

  @override
  String get authPassword => 'Mot de passe';

  @override
  String get authPasswordHint => '6 caractères minimum';

  @override
  String get authFullName => 'Nom complet';

  @override
  String get authFullNameHint => 'Votre nom et prénom';

  @override
  String get authLogin => 'Se connecter';

  @override
  String get authRegister => 'Créer le compte';

  @override
  String get authNoAccount => 'Vous n\'avez pas de compte ?';

  @override
  String get authHaveAccount => 'Vous avez déjà un compte ?';

  @override
  String get authLogout => 'Se déconnecter';

  @override
  String get authLogoutConfirm =>
      'Voulez-vous vous déconnecter de votre compte ?';

  @override
  String get authInvalidPhone => 'Saisissez un numéro algérien valide';

  @override
  String get authInvalidPassword =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get authInvalidName => 'Saisissez votre nom complet';

  @override
  String get authOtpTitle => 'Code de vérification';

  @override
  String authOtpSubtitle(String phone) {
    return 'Saisissez le code envoyé au $phone';
  }

  @override
  String get authOtpResend => 'Renvoyer le code';

  @override
  String get authOtpDisabled =>
      'La vérification par code est désactivée, utilisez votre mot de passe';

  @override
  String get authChangePassword => 'Changer le mot de passe';

  @override
  String get authCurrentPassword => 'Mot de passe actuel';

  @override
  String get authNewPassword => 'Nouveau mot de passe';

  @override
  String get locationTitle => 'Où livrons-nous ?';

  @override
  String get locationSubtitle =>
      'Placez-vous sur la carte ou saisissez votre adresse';

  @override
  String get locationUseGps => 'Utiliser ma position actuelle';

  @override
  String get locationPermissionDenied =>
      'Accès à la position refusé, saisissez votre adresse manuellement';

  @override
  String get locationServiceDisabled =>
      'La localisation est désactivée, activez-la ou saisissez votre adresse';

  @override
  String get locationManualEntry => 'Saisir l\'adresse manuellement';

  @override
  String get locationSearching => 'Recherche de votre adresse…';

  @override
  String get locationUnknownAddress =>
      'Nous n\'avons pas pu nommer ce lieu, saisissez-le vous-même';

  @override
  String get locationConfirm => 'Confirmer la position';

  @override
  String get addressTitle => 'Mes adresses';

  @override
  String get addressAdd => 'Ajouter une adresse';

  @override
  String get addressEdit => 'Modifier l\'adresse';

  @override
  String get addressLabel => 'Nom de l\'adresse';

  @override
  String get addressLabelHint => 'Maison, Travail…';

  @override
  String get addressWilaya => 'Wilaya';

  @override
  String get addressCommune => 'Commune';

  @override
  String get addressStreet => 'Rue et numéro';

  @override
  String get addressNotes => 'Notes pour le livreur';

  @override
  String get addressNotesHint => 'Étage, numéro de porte, un repère…';

  @override
  String get addressSetDefault => 'Définir comme adresse par défaut';

  @override
  String get addressDefault => 'Par défaut';

  @override
  String get addressEmpty => 'Vous n\'avez pas encore ajouté d\'adresse';

  @override
  String get addressDeleteConfirm => 'Voulez-vous supprimer cette adresse ?';

  @override
  String get homeDeliverTo => 'Livrer à';

  @override
  String get homeSearchHint => 'Que voulez-vous manger ?';

  @override
  String get homeCategories => 'Catégories';

  @override
  String get homePopularNearby => 'Les plus populaires près de vous';

  @override
  String get homeOffers => 'Offres';

  @override
  String get homeNoVendors =>
      'Aucun magasin disponible dans votre zone pour le moment';

  @override
  String get homeNoOffers => 'Aucune offre pour le moment';

  @override
  String get navHome => 'Accueil';

  @override
  String get navOrders => 'Commandes';

  @override
  String get navProfile => 'Compte';

  @override
  String get navCart => 'Panier';

  @override
  String get vendorsTitle => 'Magasins';

  @override
  String get vendorClosed => 'Actuellement fermé';

  @override
  String get vendorOpen => 'Ouvert';

  @override
  String vendorMinOrder(String amount) {
    return 'Minimum $amount';
  }

  @override
  String vendorDeliveryFee(String amount) {
    return 'Livraison $amount';
  }

  @override
  String vendorMinutes(int count) {
    return '$count min';
  }

  @override
  String vendorKm(String value) {
    return '$value km';
  }

  @override
  String vendorRatings(int count) {
    return '($count avis)';
  }

  @override
  String get vendorSearchHint => 'Rechercher dans le menu';

  @override
  String get vendorSpecialOffers => 'Offres spéciales';

  @override
  String get vendorEmptyMenu => 'Ce magasin n\'a pas encore de produits';

  @override
  String get vendorClosedCta => 'Ce magasin est actuellement fermé';

  @override
  String get filterTitle => 'Filtrer les résultats';

  @override
  String get filterOpenNow => 'Ouvert maintenant';

  @override
  String get filterHasOffer => 'Avec offres';

  @override
  String get filterSort => 'Trier par';

  @override
  String get filterSortNearest => 'Le plus proche';

  @override
  String get filterSortFastest => 'Le plus rapide';

  @override
  String get filterSortRating => 'Les mieux notés';

  @override
  String get filterSortFeatured => 'À la une';

  @override
  String get filterCategory => 'Catégorie';

  @override
  String get filterAll => 'Tout';

  @override
  String get productAddToCart => 'Ajouter au panier';

  @override
  String get productUnavailable => 'Actuellement indisponible';

  @override
  String get productQuantity => 'Quantité';

  @override
  String get productRequiredOption => 'Choix obligatoire';

  @override
  String get productChooseOne => 'Choisissez-en un';

  @override
  String get productChooseMany => 'Choisissez ce que vous voulez';

  @override
  String get productAdded => 'Ajouté à votre panier';

  @override
  String get cartTitle => 'Panier';

  @override
  String get cartEmpty => 'Votre panier est vide';

  @override
  String get cartEmptyAction => 'Parcourir les magasins';

  @override
  String get cartGoToCart => 'Aller au panier';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartClearTitle => 'Magasin différent';

  @override
  String get cartClearMessage =>
      'Votre panier contient des articles d\'un autre magasin. Le vider et recommencer ?';

  @override
  String get cartClearConfirm => 'Vider le panier';

  @override
  String cartItemCount(int count) {
    return '$count articles';
  }

  @override
  String get cartRemoveItem => 'Retirer l\'article';

  @override
  String get checkoutTitle => 'Finaliser la commande';

  @override
  String get checkoutAddress => 'Adresse de livraison';

  @override
  String get checkoutChangeAddress => 'Modifier';

  @override
  String get checkoutDeliveryType => 'Type de livraison';

  @override
  String get checkoutDeliveryNormal => 'Livraison standard';

  @override
  String get checkoutDeliveryVip => 'Livraison VIP';

  @override
  String get checkoutDeliveryVipHint => 'Préparation et livraison prioritaires';

  @override
  String get checkoutPayment => 'Moyen de paiement';

  @override
  String get checkoutPaymentCash => 'Espèces';

  @override
  String get checkoutPaymentElectronic => 'Carte';

  @override
  String get checkoutPaymentSoon => 'Bientôt disponible';

  @override
  String get checkoutVoucher => 'Bon de réduction';

  @override
  String get checkoutVoucherHint => 'Saisissez votre code';

  @override
  String get checkoutVoucherApply => 'Appliquer';

  @override
  String get checkoutVoucherRemove => 'Retirer';

  @override
  String get checkoutUsePoints => 'Utiliser mes points';

  @override
  String checkoutPointsBalance(int count) {
    return 'Vous avez $count points';
  }

  @override
  String get checkoutNote => 'Note pour le magasin';

  @override
  String get checkoutNoteHint =>
      'Par exemple : sans oignons, appelez en arrivant…';

  @override
  String get checkoutSubtotal => 'Sous-total';

  @override
  String get checkoutServiceFee => 'Frais de service';

  @override
  String get checkoutDeliveryFee => 'Livraison';

  @override
  String get checkoutDiscount => 'Remise';

  @override
  String get checkoutGrandTotal => 'Total général';

  @override
  String get checkoutSubmit => 'Commander';

  @override
  String get checkoutNoAddress => 'Ajoutez une adresse avant de commander';

  @override
  String get successTitle => 'Votre commande est enregistrée';

  @override
  String get successMessage => 'Nous vous appellerons pour la confirmer';

  @override
  String successOrderCode(String code) {
    return 'Commande n° $code';
  }

  @override
  String get successTrack => 'Suivre la commande';

  @override
  String get successBackHome => 'Retour à l\'accueil';

  @override
  String get ordersTitle => 'Mes commandes';

  @override
  String get ordersEmpty => 'Vous n\'avez encore rien commandé';

  @override
  String get ordersEmptyAction => 'Commencer mes achats';

  @override
  String get ordersActive => 'En cours';

  @override
  String get ordersHistory => 'Passées';

  @override
  String get ordersReorder => 'Commander à nouveau';

  @override
  String get ordersRate => 'Noter la commande';

  @override
  String get ordersCancel => 'Annuler la commande';

  @override
  String get ordersCancelReason => 'Motif d\'annulation';

  @override
  String get ordersCancelReasonHint => 'Dites-nous pourquoi vous annulez';

  @override
  String get ordersCancelled => 'Commande annulée';

  @override
  String get ordersDetails => 'Détails de la commande';

  @override
  String get ordersItems => 'Articles';

  @override
  String get ordersCallAgent => 'Appeler le livreur';

  @override
  String get ordersCallVendor => 'Appeler le magasin';

  @override
  String get ordersCallSupport => 'Appeler le support';

  @override
  String get ordersAgentOnWay => 'Votre livreur est en route';

  @override
  String get ordersNoAgentYet => 'Aucun livreur assigné pour l\'instant';

  @override
  String get statusPending => 'En attente de confirmation';

  @override
  String get statusConfirmed => 'Confirmée';

  @override
  String get statusSentToVendor => 'Envoyée au magasin';

  @override
  String get statusPreparing => 'En préparation';

  @override
  String get statusReady => 'Prête à être récupérée';

  @override
  String get statusAssigned => 'Assignée à un livreur';

  @override
  String get statusAccepted => 'Acceptée par le livreur';

  @override
  String get statusPickedUp => 'Récupérée';

  @override
  String get statusOnTheWay => 'En route';

  @override
  String get statusDelivered => 'Livrée';

  @override
  String get statusCancelled => 'Annulée';

  @override
  String get statusLate => 'En retard';

  @override
  String get ratingTitle => 'Comment s\'est passée votre expérience ?';

  @override
  String get ratingVendor => 'Noter le magasin';

  @override
  String get ratingAgent => 'Noter le livreur';

  @override
  String get ratingComment => 'Votre commentaire';

  @override
  String get ratingCommentHint => 'Partagez votre avis (facultatif)';

  @override
  String get ratingSubmit => 'Envoyer l\'avis';

  @override
  String get ratingThanks => 'Merci pour votre avis';

  @override
  String get profileTitle => 'Compte';

  @override
  String get profileAccount => 'Compte';

  @override
  String get profileEditProfile => 'Modifier le profil';

  @override
  String get profileMyAddresses => 'Mes adresses';

  @override
  String get profileMyPoints => 'Mes points';

  @override
  String profilePointsValue(int count) {
    return '$count points';
  }

  @override
  String get profileVouchers => 'Bons et coupons';

  @override
  String get profileSettings => 'Paramètres';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileLanguage => 'Langue';

  @override
  String get profileFollowUs => 'Suivez-nous';

  @override
  String get profileJoinUs => 'Rejoignez-nous';

  @override
  String get profileJoinUsHint =>
      'Vous avez un magasin ou souhaitez devenir livreur ?';

  @override
  String get profileSupport => 'Aide et support';

  @override
  String get profileAbout => 'À propos de Saji';

  @override
  String get profileDangerZone => 'Zone sensible';

  @override
  String get profileDeleteAccount => 'Supprimer le compte';

  @override
  String get profileDeleteConfirm =>
      'Votre compte sera définitivement supprimé. Êtes-vous sûr ?';

  @override
  String get agentTitle => 'Tableau de bord livreur';

  @override
  String get agentOnline => 'En ligne';

  @override
  String get agentOffline => 'Hors ligne';

  @override
  String get agentGoOnline => 'Commencer le travail';

  @override
  String get agentGoOffline => 'Terminer le travail';

  @override
  String get agentOfflineHint => 'Vous ne recevrez pas de commandes hors ligne';

  @override
  String get agentNewOffer => 'Nouvelle demande de livraison';

  @override
  String get agentAccept => 'Accepter';

  @override
  String get agentReject => 'Refuser';

  @override
  String get agentRejectReason => 'Motif du refus';

  @override
  String get agentRejectTooFar => 'Trop loin';

  @override
  String get agentRejectBusy => 'Occupé par une autre commande';

  @override
  String get agentRejectVehicle => 'Problème de véhicule';

  @override
  String get agentRejectOther => 'Autre motif';

  @override
  String get agentNoOffers => 'Aucune nouvelle demande pour le moment';

  @override
  String get agentActiveDelivery => 'Livraison en cours';

  @override
  String get agentNoActiveDelivery => 'Aucune livraison en cours';

  @override
  String get agentPickup => 'Récupération';

  @override
  String get agentDropoff => 'Livraison';

  @override
  String get agentNavigate => 'Ouvrir la carte';

  @override
  String get agentSwipePickedUp => 'Glissez pour confirmer la récupération';

  @override
  String get agentSwipeOnTheWay => 'Glissez pour démarrer la livraison';

  @override
  String get agentSwipeDelivered => 'Glissez pour confirmer la livraison';

  @override
  String get agentCashCollected => 'Confirmez avoir encaissé le montant';

  @override
  String agentCashAmount(String amount) {
    return 'Montant dû $amount';
  }

  @override
  String get agentHistory => 'Historique des livraisons';

  @override
  String get agentStats => 'Mes statistiques';

  @override
  String get agentDeliveries => 'Livraisons';

  @override
  String get agentEarnings => 'Gains';

  @override
  String get agentAvgTime => 'Durée moyenne';

  @override
  String get agentTodayDeliveries => 'Livraisons du jour';

  @override
  String agentOfferExpires(int seconds) {
    return '$seconds secondes restantes';
  }

  @override
  String get agentOfferExpired => 'Cette demande a expiré';

  @override
  String get agentPayout => 'Rémunération';

  @override
  String get agentDistance => 'Distance';

  @override
  String get agentLocationRunning => 'Suivi de position actif';

  @override
  String get adminDashboard => 'Tableau de bord';

  @override
  String get adminOrders => 'Commandes';

  @override
  String get adminCustomers => 'Clients';

  @override
  String get adminAgents => 'Livreurs';

  @override
  String get adminVendors => 'Magasins';

  @override
  String get adminProducts => 'Produits';

  @override
  String get adminCategories => 'Catégories';

  @override
  String get adminOffers => 'Offres';

  @override
  String get adminVouchers => 'Bons de réduction';

  @override
  String get adminAnalytics => 'Analyses';

  @override
  String get adminFleet => 'Carte de la flotte';

  @override
  String get adminSettings => 'Paramètres';

  @override
  String get adminStatTodayOrders => 'Commandes du jour';

  @override
  String get adminStatRevenue => 'Revenus';

  @override
  String get adminStatActiveDeliveries => 'Livraisons en cours';

  @override
  String get adminStatAvgTime => 'Durée moyenne de livraison';

  @override
  String get adminStatLate => 'Commandes en retard';

  @override
  String get adminStatPending => 'En attente de confirmation';

  @override
  String get adminStatOnlineAgents => 'Livreurs en ligne';

  @override
  String get adminOrderNew => 'Nouvelle commande reçue';

  @override
  String get adminOrderLate => 'Commande en retard';

  @override
  String get adminCustomerInfo => 'Informations client';

  @override
  String get adminDeliveryInfo => 'Informations de livraison';

  @override
  String get adminCustomerNote => 'Note du client';

  @override
  String get adminCallCustomer => 'Appeler le client';

  @override
  String get adminCallVendor => 'Appeler le magasin';

  @override
  String get adminConfirmOrder => 'Confirmer la commande';

  @override
  String get adminSendToVendor => 'Envoyer au magasin';

  @override
  String get adminMarkPreparing => 'Préparation commencée';

  @override
  String get adminMarkReady => 'Prête';

  @override
  String get adminAssignAgent => 'Assigner à un livreur';

  @override
  String get adminCancelOrder => 'Annuler la commande';

  @override
  String get adminCancelReason => 'Motif d\'annulation';

  @override
  String get adminAssignTitle => 'Choisir un livreur';

  @override
  String get adminAssignEmpty => 'Aucun livreur en ligne actuellement';

  @override
  String adminAgentLoad(int count) {
    return '$count commandes en cours';
  }

  @override
  String get adminSearchOrders => 'Rechercher par numéro ou téléphone';

  @override
  String get adminExportCsv => 'Exporter en CSV';

  @override
  String get adminNoOrders => 'Aucune commande correspondante';

  @override
  String get adminColOrderCode => 'N° de commande';

  @override
  String get adminColTime => 'Heure';

  @override
  String get adminColStatus => 'Statut';

  @override
  String get adminColUses => 'Utilisations';

  @override
  String get adminColName => 'Nom';

  @override
  String get adminColActions => 'Actions';

  @override
  String get adminVendorNew => 'Nouveau magasin';

  @override
  String get adminVendorEdit => 'Modifier le magasin';

  @override
  String get adminVendorName => 'Nom du magasin';

  @override
  String get adminVendorSlug => 'Identifiant';

  @override
  String get adminVendorDescription => 'Description';

  @override
  String get adminVendorPhone => 'Téléphone du magasin';

  @override
  String get adminVendorAddress => 'Adresse';

  @override
  String get adminVendorLocation => 'Position sur la carte';

  @override
  String get adminVendorHours => 'Horaires d\'ouverture';

  @override
  String get adminVendorFees => 'Frais';

  @override
  String get adminVendorPrepTime => 'Temps de préparation (minutes)';

  @override
  String get adminVendorFeatured => 'Magasin à la une';

  @override
  String get adminVendorIsOpen => 'Ouvert';

  @override
  String get adminVendorLogo => 'Logo';

  @override
  String get adminVendorCover => 'Image de couverture';

  @override
  String get adminSectionNew => 'Nouvelle section';

  @override
  String get adminSectionName => 'Nom de la section';

  @override
  String get adminProductNew => 'Nouveau produit';

  @override
  String get adminProductEdit => 'Modifier le produit';

  @override
  String get adminProductName => 'Nom du produit';

  @override
  String get adminProductPrice => 'Prix en dinars';

  @override
  String get adminProductAvailable => 'Disponible';

  @override
  String get adminProductOptions => 'Options';

  @override
  String get adminProductOptionName => 'Nom de l\'option';

  @override
  String get adminProductOptionValue => 'Valeur';

  @override
  String get adminProductOptionDelta => 'Différence de prix';

  @override
  String get adminProductAddOption => 'Ajouter une option';

  @override
  String get adminProductBulkAvailable => 'Activer la sélection';

  @override
  String get adminProductBulkUnavailable => 'Désactiver la sélection';

  @override
  String get adminOfferNew => 'Nouvelle offre';

  @override
  String get adminOfferTitle => 'Titre de l\'offre';

  @override
  String get adminOfferSubtitle => 'Sous-titre';

  @override
  String get adminOfferType => 'Type d\'offre';

  @override
  String get adminOfferTypePercentage => 'Pourcentage';

  @override
  String get adminOfferTypeFixed => 'Montant fixe';

  @override
  String get adminOfferTypeFreeDelivery => 'Livraison gratuite';

  @override
  String get adminOfferTypeBundle => 'Lot';

  @override
  String get adminOfferValue => 'Valeur';

  @override
  String get adminOfferScope => 'Portée de l\'offre';

  @override
  String get adminOfferPlatform => 'Toute la plateforme';

  @override
  String get adminOfferSchedule => 'Période';

  @override
  String get adminOfferShowOnHome => 'Afficher sur l\'accueil';

  @override
  String get adminOfferPreview => 'Aperçu';

  @override
  String get adminVoucherNew => 'Nouveau bon';

  @override
  String get adminVoucherCode => 'Code';

  @override
  String get adminVoucherMinOrder => 'Commande minimum';

  @override
  String get adminVoucherMaxUses => 'Utilisations maximum';

  @override
  String get adminVoucherPerUser => 'Par utilisateur';

  @override
  String adminVoucherUsed(int count) {
    return 'Utilisé $count fois';
  }

  @override
  String get adminAgentNew => 'Nouveau livreur';

  @override
  String get adminAgentTempPassword => 'Mot de passe temporaire';

  @override
  String get adminAgentSuspend => 'Suspendre le compte';

  @override
  String get adminAgentActivate => 'Activer le compte';

  @override
  String get adminCustomerBlock => 'Bloquer le client';

  @override
  String get adminCustomerUnblock => 'Débloquer';

  @override
  String get adminCustomerBlocked => 'Bloqué';

  @override
  String get adminCustomerOrders => 'Nombre de commandes';

  @override
  String get adminCustomerSpent => 'Total dépensé';

  @override
  String get adminAnalyticsOrdersOverTime => 'Commandes dans le temps';

  @override
  String get adminAnalyticsTopVendors => 'Meilleurs magasins';

  @override
  String get adminAnalyticsTopProducts => 'Produits les plus vendus';

  @override
  String get adminAnalyticsAgents => 'Classement des livreurs';

  @override
  String get adminAnalyticsCancellations => 'Motifs d\'annulation';

  @override
  String get adminAnalyticsRange => 'Période';

  @override
  String get adminFleetIdle => 'Disponible';

  @override
  String get adminFleetOnDelivery => 'En livraison';

  @override
  String get adminFleetEmpty => 'Aucun livreur en ligne';

  @override
  String adminFleetLastSeen(String time) {
    return 'Vu à $time';
  }

  @override
  String get settingsServiceFee => 'Frais de service';

  @override
  String get settingsMinVendorFee => 'Frais de livraison minimum du magasin';

  @override
  String get settingsMaxVendorFee => 'Frais de livraison maximum du magasin';

  @override
  String get settingsVipSurcharge => 'Supplément VIP';

  @override
  String get settingsAssignTimeout => 'Délai d\'acceptation (secondes)';

  @override
  String get settingsLateThreshold => 'Seuil de retard (minutes)';

  @override
  String get settingsSupportPhone => 'Téléphone du support';

  @override
  String get settingsDeliveryRadius => 'Rayon de livraison (km)';

  @override
  String get settingsPointsPerHundred => 'Points par 100 DA';

  @override
  String get settingsPointValue => 'Valeur du point en centimes';

  @override
  String get settingsMaxPointsPercent =>
      'Part maximale des points sur le total';

  @override
  String get settingsElectronicPayment => 'Activer le paiement électronique';

  @override
  String get settingsSaved => 'Paramètres enregistrés';

  @override
  String get emptyTitle => 'Rien à afficher';

  @override
  String get emptySearch => 'Aucun résultat pour votre recherche';

  @override
  String get errorRetryTitle => 'Impossible de charger les données';

  @override
  String get offlineBanner =>
      'Vous êtes hors ligne — données enregistrées affichées';

  @override
  String get currencySymbol => 'DA';

  @override
  String amountWithCurrency(String amount) {
    return '$amount DA';
  }

  @override
  String get adminImagePick => 'Appuyez pour choisir une image';

  @override
  String get adminImageRemove => 'Supprimer l\'image';

  @override
  String get adminProductImage => 'Image du produit';

  @override
  String get adminOfferImage => 'Image de l\'offre';

  @override
  String get vouchersEmptyTitle => 'Aucun bon';

  @override
  String get vouchersEmptyMessage => 'Les bons disponibles apparaîtront ici';

  @override
  String get vouchersCopy => 'Copier le code';

  @override
  String get vouchersFreeDelivery => 'Livraison gratuite';

  @override
  String vouchersCopied(String code) {
    return '$code copié';
  }

  @override
  String vouchersMinOrder(String amount) {
    return 'Commande minimum $amount';
  }

  @override
  String vouchersExpires(String date) {
    return 'Expire le $date';
  }

  @override
  String vouchersPercentOff(String value) {
    return '$value% de remise';
  }

  @override
  String vouchersAmountOff(String amount) {
    return '$amount de remise';
  }

  @override
  String get notificationsCategories => 'Types de notifications';

  @override
  String get notificationsOrderUpdates => 'Suivi de commande';

  @override
  String get notificationsOrderUpdatesHint => 'Alertes au changement de statut';

  @override
  String get notificationsPromotions => 'Offres';

  @override
  String get notificationsPromotionsHint => 'Nouvelles remises et bons';

  @override
  String get notificationsNewVendors => 'Nouveaux magasins';

  @override
  String get notificationsNewVendorsHint =>
      'Quand un magasin ouvre près de vous';

  @override
  String get notificationsEnabled => 'Notifications activées';

  @override
  String get notificationsEnabledHint =>
      'Vous recevrez des alertes selon vos choix';

  @override
  String get notificationsDisabled => 'Notifications désactivées';

  @override
  String get notificationsDisabledHint =>
      'Activez-les pour suivre votre commande';

  @override
  String get notificationsEnable => 'Activer';

  @override
  String get languageHint => 'La langue s\'applique à toute l\'application';

  @override
  String get portalTitle => 'Mon magasin';

  @override
  String get portalOpen => 'Magasin ouvert — commandes acceptées';

  @override
  String get portalClosed => 'Magasin fermé — commandes refusées';

  @override
  String get portalSections => 'Sections';

  @override
  String get portalAddSection => 'Ajouter une section';

  @override
  String get portalSectionName => 'Nom de la section';

  @override
  String get portalDeleteSectionHint =>
      'La section sera supprimée ; ses produits resteront sans section';

  @override
  String get portalAddProduct => 'Nouveau produit';

  @override
  String get portalEditProduct => 'Modifier le produit';

  @override
  String get portalUnsectioned => 'Sans section';

  @override
  String get portalUnavailable => 'Indisponible';

  @override
  String get portalEmptyTitle => 'Votre menu est vide';

  @override
  String get portalDelivery => 'Livraison';

  @override
  String get portalDeliveryFee => 'Frais de livraison';

  @override
  String get portalDeliveryFeeHint =>
      'Ce que le client paie pour la livraison depuis votre magasin';

  @override
  String get portalMinOrder => 'Commande minimum';

  @override
  String get portalPrepTime => 'Temps de préparation (min)';

  @override
  String get portalPrepTimeTo => 'à';

  @override
  String get portalEditDelivery => 'Modifier les paramètres de livraison';

  @override
  String portalFeeRange(String min, String max) {
    return 'Plage autorisée : $min – $max';
  }

  @override
  String get portalSaved => 'Enregistré';

  @override
  String get portalEmptyMessage =>
      'Ajoutez vos sections et produits pour que les clients les voient';

  @override
  String get adminVendorAccount => 'Compte du magasin';

  @override
  String get adminVendorAccountCreate => 'Créer un accès';

  @override
  String get adminVendorAccountExists => 'Ce magasin a un accès';

  @override
  String get adminVendorAccountNone => 'Aucun accès';

  @override
  String get adminVendorAccountHint =>
      'Le gérant se connecte pour gérer son menu uniquement';

  @override
  String get adminVendorAccountRevoke => 'Supprimer le compte';

  @override
  String get adminInvalidName =>
      'Le nom doit contenir au moins deux caractères';

  @override
  String get adminInvalidCategory => 'Choisissez une catégorie pour le magasin';

  @override
  String get adminInvalidSlug =>
      'L\'identifiant doit contenir au moins deux caractères';

  @override
  String get adminInvalidSlugChars =>
      'Minuscules, chiffres et tirets uniquement';

  @override
  String get adminInvalidPhone => 'Numéro de téléphone invalide';

  @override
  String get adminInvalidAddress => 'L\'adresse est trop courte';

  @override
  String get adminInvalidNumber => 'Saisissez un nombre valide';
}
