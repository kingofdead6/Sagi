// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Saji';

  @override
  String get welcomeTitle => 'Welcome to Saji';

  @override
  String get welcomeSubtitle => 'Everything you need, delivered to your door';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonClose => 'Close';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonNext => 'Next';

  @override
  String get commonBack => 'Back';

  @override
  String get commonSeeAll => 'See all';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonOptional => 'Optional';

  @override
  String get commonRequired => 'Required';

  @override
  String get commonCall => 'Call';

  @override
  String get commonFilter => 'Filter';

  @override
  String get commonApply => 'Apply';

  @override
  String get commonReset => 'Reset';

  @override
  String get commonToday => 'Today';

  @override
  String get commonNone => 'None';

  @override
  String get commonRefresh => 'Refresh';

  @override
  String get commonExport => 'Export';

  @override
  String get errorGeneric => 'Something went wrong, please try again';

  @override
  String get errorNetwork => 'No internet connection, check your network';

  @override
  String get errorTimeout => 'The request took too long, please try again';

  @override
  String get errorServer => 'The server is not responding, try again shortly';

  @override
  String get errorUnauthorized => 'Your session expired, please sign in again';

  @override
  String get errorForbidden => 'You do not have permission for this action';

  @override
  String get errorNotFound => 'Item not found';

  @override
  String get errorConflict => 'This action cannot be completed right now';

  @override
  String get errorValidation => 'Please check the information you entered';

  @override
  String get errorTooMany => 'Too many attempts, please wait a moment';

  @override
  String get authLoginTitle => 'Sign in';

  @override
  String get authRegisterTitle => 'Create an account';

  @override
  String get authPhone => 'Phone number';

  @override
  String get authPhoneHint => '0X XX XX XX XX';

  @override
  String get authPassword => 'Password';

  @override
  String get authPasswordHint => 'At least 6 characters';

  @override
  String get authFullName => 'Full name';

  @override
  String get authFullNameHint => 'Your first and last name';

  @override
  String get authLogin => 'Sign in';

  @override
  String get authRegister => 'Create account';

  @override
  String get authNoAccount => 'Do not have an account?';

  @override
  String get authHaveAccount => 'Already have an account?';

  @override
  String get authLogout => 'Sign out';

  @override
  String get authLogoutConfirm => 'Do you want to sign out of your account?';

  @override
  String get authInvalidPhone => 'Enter a valid Algerian phone number';

  @override
  String get authInvalidPassword => 'Password must be at least 6 characters';

  @override
  String get authInvalidName => 'Enter your full name';

  @override
  String get authOtpTitle => 'Verification code';

  @override
  String authOtpSubtitle(String phone) {
    return 'Enter the code sent to $phone';
  }

  @override
  String get authOtpResend => 'Resend code';

  @override
  String get authOtpDisabled =>
      'Code verification is currently disabled, use your password';

  @override
  String get authChangePassword => 'Change password';

  @override
  String get authCurrentPassword => 'Current password';

  @override
  String get authNewPassword => 'New password';

  @override
  String get locationTitle => 'Where should we deliver?';

  @override
  String get locationSubtitle =>
      'Pick your spot on the map or type your address';

  @override
  String get locationUseGps => 'Use my current location';

  @override
  String get locationPermissionDenied =>
      'Location access denied, enter your address manually';

  @override
  String get locationServiceDisabled =>
      'Location services are off, turn them on or enter your address manually';

  @override
  String get locationManualEntry => 'Enter address manually';

  @override
  String get locationSearching => 'Finding your address…';

  @override
  String get locationUnknownAddress =>
      'We could not name this place, please type it yourself';

  @override
  String get locationConfirm => 'Confirm location';

  @override
  String get addressTitle => 'My addresses';

  @override
  String get addressAdd => 'Add address';

  @override
  String get addressEdit => 'Edit address';

  @override
  String get addressLabel => 'Address name';

  @override
  String get addressLabelHint => 'Home, Work…';

  @override
  String get addressWilaya => 'Wilaya';

  @override
  String get addressCommune => 'Commune';

  @override
  String get addressStreet => 'Street and number';

  @override
  String get addressNotes => 'Notes for the driver';

  @override
  String get addressNotesHint => 'Floor, door number, a landmark…';

  @override
  String get addressSetDefault => 'Set as default address';

  @override
  String get addressDefault => 'Default';

  @override
  String get addressEmpty => 'You have not added an address yet';

  @override
  String get addressDeleteConfirm => 'Do you want to delete this address?';

  @override
  String get homeDeliverTo => 'Deliver to';

  @override
  String get homeSearchHint => 'What would you like to eat?';

  @override
  String get homeCategories => 'Categories';

  @override
  String get homePopularNearby => 'Most popular near you';

  @override
  String get homeOffers => 'Offers';

  @override
  String get homeNoVendors => 'No stores are available in your area right now';

  @override
  String get homeNoOffers => 'No offers right now';

  @override
  String get navHome => 'Home';

  @override
  String get navOrders => 'Orders';

  @override
  String get navProfile => 'Account';

  @override
  String get navCart => 'Basket';

  @override
  String get vendorsTitle => 'Stores';

  @override
  String get vendorClosed => 'Currently closed';

  @override
  String get vendorOpen => 'Open';

  @override
  String vendorMinOrder(String amount) {
    return 'Minimum $amount';
  }

  @override
  String vendorDeliveryFee(String amount) {
    return 'Delivery $amount';
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
    return '($count ratings)';
  }

  @override
  String get vendorSearchHint => 'Search the menu';

  @override
  String get vendorSpecialOffers => 'Special offers';

  @override
  String get vendorEmptyMenu => 'This store has no products yet';

  @override
  String get vendorClosedCta => 'This store is currently closed';

  @override
  String get filterTitle => 'Filter results';

  @override
  String get filterOpenNow => 'Open now';

  @override
  String get filterHasOffer => 'Has offers';

  @override
  String get filterSort => 'Sort by';

  @override
  String get filterSortNearest => 'Nearest';

  @override
  String get filterSortFastest => 'Fastest';

  @override
  String get filterSortRating => 'Top rated';

  @override
  String get filterSortFeatured => 'Featured';

  @override
  String get filterCategory => 'Category';

  @override
  String get filterAll => 'All';

  @override
  String get productAddToCart => 'Add to basket';

  @override
  String get productUnavailable => 'Currently unavailable';

  @override
  String get productQuantity => 'Quantity';

  @override
  String get productRequiredOption => 'Selection required';

  @override
  String get productChooseOne => 'Choose one';

  @override
  String get productChooseMany => 'Choose what you like';

  @override
  String get productAdded => 'Added to your basket';

  @override
  String get cartTitle => 'Basket';

  @override
  String get cartEmpty => 'Your basket is empty';

  @override
  String get cartEmptyAction => 'Browse stores';

  @override
  String get cartGoToCart => 'Go to basket';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartClearTitle => 'Different store';

  @override
  String get cartClearMessage =>
      'Your basket has items from another store. Empty it and start over?';

  @override
  String get cartClearConfirm => 'Empty basket';

  @override
  String cartItemCount(int count) {
    return '$count items';
  }

  @override
  String get cartRemoveItem => 'Remove item';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutAddress => 'Delivery address';

  @override
  String get checkoutChangeAddress => 'Change';

  @override
  String get checkoutDeliveryType => 'Delivery type';

  @override
  String get checkoutDeliveryNormal => 'Standard delivery';

  @override
  String get checkoutDeliveryVip => 'VIP delivery';

  @override
  String get checkoutDeliveryVipHint => 'Priority preparation and delivery';

  @override
  String get checkoutPayment => 'Payment method';

  @override
  String get checkoutPaymentCash => 'Cash';

  @override
  String get checkoutPaymentElectronic => 'Card';

  @override
  String get checkoutPaymentSoon => 'Coming soon';

  @override
  String get checkoutVoucher => 'Voucher';

  @override
  String get checkoutVoucherHint => 'Enter your voucher code';

  @override
  String get checkoutVoucherApply => 'Apply';

  @override
  String get checkoutVoucherRemove => 'Remove';

  @override
  String get checkoutUsePoints => 'Use my points';

  @override
  String checkoutPointsBalance(int count) {
    return 'You have $count points';
  }

  @override
  String get checkoutNote => 'Note for the store';

  @override
  String get checkoutNoteHint => 'For example: no onions, call on arrival…';

  @override
  String get checkoutSubtotal => 'Subtotal';

  @override
  String get checkoutServiceFee => 'Service fee';

  @override
  String get checkoutDeliveryFee => 'Delivery';

  @override
  String get checkoutDiscount => 'Discount';

  @override
  String get checkoutGrandTotal => 'Grand total';

  @override
  String get checkoutSubmit => 'Place order';

  @override
  String get checkoutNoAddress => 'Add an address before placing your order';

  @override
  String get successTitle => 'Your order is in';

  @override
  String get successMessage => 'We will call you to confirm it';

  @override
  String successOrderCode(String code) {
    return 'Order number $code';
  }

  @override
  String get successTrack => 'Track order';

  @override
  String get successBackHome => 'Back to home';

  @override
  String get ordersTitle => 'My orders';

  @override
  String get ordersEmpty => 'You have not ordered anything yet';

  @override
  String get ordersEmptyAction => 'Start shopping';

  @override
  String get ordersActive => 'Active';

  @override
  String get ordersHistory => 'Past';

  @override
  String get ordersReorder => 'Order again';

  @override
  String get ordersRate => 'Rate order';

  @override
  String get ordersCancel => 'Cancel order';

  @override
  String get ordersCancelReason => 'Reason for cancelling';

  @override
  String get ordersCancelReasonHint => 'Tell us why you want to cancel';

  @override
  String get ordersCancelled => 'Order cancelled';

  @override
  String get ordersDetails => 'Order details';

  @override
  String get ordersItems => 'Items';

  @override
  String get ordersCallAgent => 'Call the driver';

  @override
  String get ordersCallVendor => 'Call the store';

  @override
  String get ordersCallSupport => 'Call support';

  @override
  String get ordersAgentOnWay => 'Your driver is on the way';

  @override
  String get ordersNoAgentYet => 'No driver assigned yet';

  @override
  String get statusPending => 'Awaiting confirmation';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusSentToVendor => 'Sent to store';

  @override
  String get statusPreparing => 'Being prepared';

  @override
  String get statusReady => 'Ready for pickup';

  @override
  String get statusAssigned => 'Assigned to a driver';

  @override
  String get statusAccepted => 'Accepted by driver';

  @override
  String get statusPickedUp => 'Picked up';

  @override
  String get statusOnTheWay => 'On the way';

  @override
  String get statusDelivered => 'Delivered';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusLate => 'Late';

  @override
  String get ratingTitle => 'How was your experience?';

  @override
  String get ratingVendor => 'Rate the store';

  @override
  String get ratingAgent => 'Rate the driver';

  @override
  String get ratingComment => 'Your comment';

  @override
  String get ratingCommentHint => 'Share your thoughts (optional)';

  @override
  String get ratingSubmit => 'Submit rating';

  @override
  String get ratingThanks => 'Thanks for your rating';

  @override
  String get profileTitle => 'Account';

  @override
  String get profileAccount => 'Account';

  @override
  String get profileEditProfile => 'Edit profile';

  @override
  String get profileMyAddresses => 'My addresses';

  @override
  String get profileMyPoints => 'My points';

  @override
  String profilePointsValue(int count) {
    return '$count points';
  }

  @override
  String get profileVouchers => 'Vouchers and coupons';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileFollowUs => 'Follow us';

  @override
  String get profileJoinUs => 'Join us';

  @override
  String get profileJoinUsHint => 'Own a store, or want to drive with us?';

  @override
  String get profileSupport => 'Help and support';

  @override
  String get profileAbout => 'About Saji';

  @override
  String get profileDangerZone => 'Danger zone';

  @override
  String get profileDeleteAccount => 'Delete account';

  @override
  String get profileDeleteConfirm =>
      'Your account will be permanently deleted. Are you sure?';

  @override
  String get agentTitle => 'Driver dashboard';

  @override
  String get agentOnline => 'Online';

  @override
  String get agentOffline => 'Offline';

  @override
  String get agentGoOnline => 'Start working';

  @override
  String get agentGoOffline => 'Stop working';

  @override
  String get agentOfflineHint => 'You will not receive orders while offline';

  @override
  String get agentNewOffer => 'New delivery request';

  @override
  String get agentAccept => 'Accept';

  @override
  String get agentReject => 'Decline';

  @override
  String get agentRejectReason => 'Reason for declining';

  @override
  String get agentRejectTooFar => 'Too far away';

  @override
  String get agentRejectBusy => 'Busy with another order';

  @override
  String get agentRejectVehicle => 'Vehicle problem';

  @override
  String get agentRejectOther => 'Another reason';

  @override
  String get agentNoOffers => 'No new requests right now';

  @override
  String get agentActiveDelivery => 'Current delivery';

  @override
  String get agentNoActiveDelivery => 'No delivery in progress';

  @override
  String get agentPickup => 'Pickup';

  @override
  String get agentDropoff => 'Drop-off';

  @override
  String get agentNavigate => 'Open map';

  @override
  String get agentSwipePickedUp => 'Swipe to confirm pickup';

  @override
  String get agentSwipeOnTheWay => 'Swipe to start delivery';

  @override
  String get agentSwipeDelivered => 'Swipe to confirm delivery';

  @override
  String get agentCashCollected => 'Confirm you collected the cash';

  @override
  String agentCashAmount(String amount) {
    return 'Amount due $amount';
  }

  @override
  String get agentHistory => 'Delivery history';

  @override
  String get agentStats => 'My stats';

  @override
  String get agentDeliveries => 'Deliveries';

  @override
  String get agentEarnings => 'Earnings';

  @override
  String get agentAvgTime => 'Average time';

  @override
  String get agentTodayDeliveries => 'Deliveries today';

  @override
  String agentOfferExpires(int seconds) {
    return '$seconds seconds left';
  }

  @override
  String get agentOfferExpired => 'This request has expired';

  @override
  String get agentPayout => 'Delivery pay';

  @override
  String get agentDistance => 'Distance';

  @override
  String get agentLocationRunning => 'Location tracking is on';

  @override
  String get adminDashboard => 'Dashboard';

  @override
  String get adminOrders => 'Orders';

  @override
  String get adminCustomers => 'Customers';

  @override
  String get adminAgents => 'Drivers';

  @override
  String get adminVendors => 'Stores';

  @override
  String get adminProducts => 'Products';

  @override
  String get adminCategories => 'Categories';

  @override
  String get adminOffers => 'Offers';

  @override
  String get adminVouchers => 'Vouchers';

  @override
  String get adminAnalytics => 'Analytics';

  @override
  String get adminFleet => 'Fleet map';

  @override
  String get adminSettings => 'Settings';

  @override
  String get adminStatTodayOrders => 'Orders today';

  @override
  String get adminStatRevenue => 'Revenue';

  @override
  String get adminStatActiveDeliveries => 'Active deliveries';

  @override
  String get adminStatAvgTime => 'Average delivery time';

  @override
  String get adminStatLate => 'Late orders';

  @override
  String get adminStatPending => 'Awaiting confirmation';

  @override
  String get adminStatOnlineAgents => 'Drivers online';

  @override
  String get adminOrderNew => 'New order received';

  @override
  String get adminOrderLate => 'Late order';

  @override
  String get adminCustomerInfo => 'Customer details';

  @override
  String get adminDeliveryInfo => 'Delivery details';

  @override
  String get adminCustomerNote => 'Note from the customer';

  @override
  String get adminCallCustomer => 'Call the customer';

  @override
  String get adminCallVendor => 'Call the store';

  @override
  String get adminConfirmOrder => 'Confirm order';

  @override
  String get adminSendToVendor => 'Send to store';

  @override
  String get adminMarkPreparing => 'Preparation started';

  @override
  String get adminMarkReady => 'Ready';

  @override
  String get adminAssignAgent => 'Assign to a driver';

  @override
  String get adminCancelOrder => 'Cancel order';

  @override
  String get adminCancelReason => 'Reason for cancelling';

  @override
  String get adminAssignTitle => 'Choose a driver';

  @override
  String get adminAssignEmpty => 'No driver is online right now';

  @override
  String adminAgentLoad(int count) {
    return '$count active orders';
  }

  @override
  String get adminSearchOrders => 'Search by order number or phone';

  @override
  String get adminExportCsv => 'Export CSV';

  @override
  String get adminNoOrders => 'No matching orders';

  @override
  String get adminColOrderCode => 'Order number';

  @override
  String get adminColTime => 'Time';

  @override
  String get adminColStatus => 'Status';

  @override
  String get adminColUses => 'Uses';

  @override
  String get adminColName => 'Name';

  @override
  String get adminColActions => 'Actions';

  @override
  String get adminVendorNew => 'New store';

  @override
  String get adminVendorEdit => 'Edit store';

  @override
  String get adminVendorName => 'Store name';

  @override
  String get adminVendorSlug => 'Slug';

  @override
  String get adminVendorDescription => 'Description';

  @override
  String get adminVendorPhone => 'Store phone';

  @override
  String get adminVendorAddress => 'Address';

  @override
  String get adminVendorLocation => 'Location on the map';

  @override
  String get adminVendorHours => 'Opening hours';

  @override
  String get adminVendorFees => 'Fees';

  @override
  String get adminVendorPrepTime => 'Preparation time (minutes)';

  @override
  String get adminVendorFeatured => 'Featured store';

  @override
  String get adminVendorIsOpen => 'Open';

  @override
  String get adminVendorLogo => 'Logo';

  @override
  String get adminVendorCover => 'Cover image';

  @override
  String get adminSectionNew => 'New section';

  @override
  String get adminSectionName => 'Section name';

  @override
  String get adminProductNew => 'New product';

  @override
  String get adminProductEdit => 'Edit product';

  @override
  String get adminProductName => 'Product name';

  @override
  String get adminProductPrice => 'Price in dinars';

  @override
  String get adminProductAvailable => 'Available';

  @override
  String get adminProductOptions => 'Options';

  @override
  String get adminProductOptionName => 'Option name';

  @override
  String get adminProductOptionValue => 'Value';

  @override
  String get adminProductOptionDelta => 'Price difference';

  @override
  String get adminProductAddOption => 'Add option';

  @override
  String get adminProductBulkAvailable => 'Enable selected';

  @override
  String get adminProductBulkUnavailable => 'Disable selected';

  @override
  String get adminOfferNew => 'New offer';

  @override
  String get adminOfferTitle => 'Offer title';

  @override
  String get adminOfferSubtitle => 'Subtitle';

  @override
  String get adminOfferType => 'Offer type';

  @override
  String get adminOfferTypePercentage => 'Percentage';

  @override
  String get adminOfferTypeFixed => 'Fixed amount';

  @override
  String get adminOfferTypeFreeDelivery => 'Free delivery';

  @override
  String get adminOfferTypeBundle => 'Bundle';

  @override
  String get adminOfferValue => 'Value';

  @override
  String get adminOfferScope => 'Offer scope';

  @override
  String get adminOfferPlatform => 'Whole platform';

  @override
  String get adminOfferSchedule => 'Period';

  @override
  String get adminOfferShowOnHome => 'Show on the home screen';

  @override
  String get adminOfferPreview => 'Preview';

  @override
  String get adminVoucherNew => 'New voucher';

  @override
  String get adminVoucherCode => 'Code';

  @override
  String get adminVoucherMinOrder => 'Minimum order';

  @override
  String get adminVoucherMaxUses => 'Maximum uses';

  @override
  String get adminVoucherPerUser => 'Per user';

  @override
  String adminVoucherUsed(int count) {
    return 'Used $count times';
  }

  @override
  String get adminAgentNew => 'New driver';

  @override
  String get adminAgentTempPassword => 'Temporary password';

  @override
  String get adminAgentSuspend => 'Suspend account';

  @override
  String get adminAgentActivate => 'Activate account';

  @override
  String get adminCustomerBlock => 'Block customer';

  @override
  String get adminCustomerUnblock => 'Unblock';

  @override
  String get adminCustomerBlocked => 'Blocked';

  @override
  String get adminCustomerOrders => 'Order count';

  @override
  String get adminCustomerSpent => 'Total spent';

  @override
  String get adminAnalyticsOrdersOverTime => 'Orders over time';

  @override
  String get adminAnalyticsTopVendors => 'Top stores';

  @override
  String get adminAnalyticsTopProducts => 'Best selling products';

  @override
  String get adminAnalyticsAgents => 'Driver ranking';

  @override
  String get adminAnalyticsCancellations => 'Cancellation reasons';

  @override
  String get adminAnalyticsRange => 'Period';

  @override
  String get adminFleetIdle => 'Idle';

  @override
  String get adminFleetOnDelivery => 'On delivery';

  @override
  String get adminFleetEmpty => 'No driver is online';

  @override
  String adminFleetLastSeen(String time) {
    return 'Last seen $time';
  }

  @override
  String get settingsServiceFee => 'Service fee';

  @override
  String get settingsVipSurcharge => 'VIP surcharge';

  @override
  String get settingsAssignTimeout => 'Order acceptance timeout (seconds)';

  @override
  String get settingsLateThreshold => 'Late threshold (minutes)';

  @override
  String get settingsSupportPhone => 'Support phone';

  @override
  String get settingsDeliveryRadius => 'Delivery radius (km)';

  @override
  String get settingsPointsPerHundred => 'Points per 100 DZD';

  @override
  String get settingsPointValue => 'Point value in centimes';

  @override
  String get settingsMaxPointsPercent => 'Maximum points share of the total';

  @override
  String get settingsElectronicPayment => 'Enable electronic payment';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get emptyTitle => 'Nothing here yet';

  @override
  String get emptySearch => 'No results for your search';

  @override
  String get errorRetryTitle => 'Could not load the data';

  @override
  String get offlineBanner => 'You are offline — showing the last saved data';

  @override
  String get currencySymbol => 'DZD';

  @override
  String amountWithCurrency(String amount) {
    return '$amount DZD';
  }

  @override
  String get adminImagePick => 'Tap to choose an image';

  @override
  String get adminImageRemove => 'Remove image';

  @override
  String get adminProductImage => 'Product image';

  @override
  String get adminOfferImage => 'Offer image';

  @override
  String get vouchersEmptyTitle => 'No vouchers';

  @override
  String get vouchersEmptyMessage =>
      'Vouchers available to you will appear here';

  @override
  String get vouchersCopy => 'Copy code';

  @override
  String get vouchersFreeDelivery => 'Free delivery';

  @override
  String vouchersCopied(String code) {
    return 'Copied $code';
  }

  @override
  String vouchersMinOrder(String amount) {
    return 'Minimum order $amount';
  }

  @override
  String vouchersExpires(String date) {
    return 'Expires on $date';
  }

  @override
  String vouchersPercentOff(String value) {
    return '$value% off';
  }

  @override
  String vouchersAmountOff(String amount) {
    return '$amount off';
  }

  @override
  String get notificationsCategories => 'Notification types';

  @override
  String get notificationsOrderUpdates => 'Order updates';

  @override
  String get notificationsOrderUpdatesHint =>
      'Alerts when your order status changes';

  @override
  String get notificationsPromotions => 'Offers';

  @override
  String get notificationsPromotionsHint => 'New discounts and vouchers';

  @override
  String get notificationsNewVendors => 'New stores';

  @override
  String get notificationsNewVendorsHint => 'When a store opens near you';

  @override
  String get notificationsEnabled => 'Notifications are on';

  @override
  String get notificationsEnabledHint =>
      'You will get alerts based on your choices';

  @override
  String get notificationsDisabled => 'Notifications are off';

  @override
  String get notificationsDisabledHint => 'Turn them on to follow your order';

  @override
  String get notificationsEnable => 'Turn on';

  @override
  String get languageHint => 'The language applies to the whole app';

  @override
  String get portalTitle => 'My store';

  @override
  String get portalOpen => 'Store is open — accepting orders';

  @override
  String get portalClosed => 'Store is closed — not accepting orders';

  @override
  String get portalSections => 'Sections';

  @override
  String get portalAddSection => 'Add section';

  @override
  String get portalSectionName => 'Section name';

  @override
  String get portalDeleteSectionHint =>
      'The section will be deleted; its products stay without a section';

  @override
  String get portalAddProduct => 'New product';

  @override
  String get portalEditProduct => 'Edit product';

  @override
  String get portalUnsectioned => 'No section';

  @override
  String get portalUnavailable => 'Unavailable';

  @override
  String get portalEmptyTitle => 'Your menu is empty';

  @override
  String get portalEmptyMessage =>
      'Add sections and products so customers can see them';

  @override
  String get adminVendorAccount => 'Store account';

  @override
  String get adminVendorAccountCreate => 'Create a login';

  @override
  String get adminVendorAccountExists => 'This store has a login';

  @override
  String get adminVendorAccountNone => 'No login yet';

  @override
  String get adminVendorAccountHint =>
      'The owner signs in to manage their menu only';

  @override
  String get adminVendorAccountRevoke => 'Delete the account';

  @override
  String get adminInvalidName => 'The name must be at least two characters';

  @override
  String get adminInvalidCategory => 'Choose a category for the store';

  @override
  String get adminInvalidSlug => 'The slug must be at least two characters';

  @override
  String get adminInvalidSlugChars =>
      'Lowercase letters, numbers and dashes only';

  @override
  String get adminInvalidPhone => 'Invalid phone number';

  @override
  String get adminInvalidAddress => 'The address is too short';

  @override
  String get adminInvalidNumber => 'Enter a valid number';
}
