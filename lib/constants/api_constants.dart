import 'dart:io';

import 'package:get/get.dart';

class ApiConstant {
  static const baseUrl =
      "http://ec2-13-233-147-132.ap-south-1.compute.amazonaws.com:8080/api/";
  static const baseUrl1 =
      "http://ec2-13-233-147-132.ap-south-1.compute.amazonaws.com:8080/";
  static const city =
      "http://api-bishnoivivah.e0esalb985nja.ap-south-1.cs.amazonlightsail.com";
  static const generateOtp = "auth/generateOtp";
  static const validateOTP = "auth/validateOTP";
  static const createProfile = "vendor/registerVendor?vendorType=";
  static const contactInfo = "vendor/contact-details";
  static const basicDetails = "vendor/basic-details";
  static const servicesAndPricing = "vendor/services-and-pricing";
  static const getPhotoAlbum = "vendor/photo/albums?vendorId=";
  static const createPhotoAlbum = "vendor/photo/upload";
  static const kycUpload = "kyc/upload";
  static const updateProfilePhoto = "vendor/photo/profile-photo/";
  static const updateAlbumCover = "vendor/photo/album-cover/";
  static const getYoutubeAlbum = "vendor/photo/youtube-video";
  static const getKycDocumentUpload = "kyc/getVendorDocuments";
  static const getUserProfile = "vendor/";
  static const getVendorReviews = "vendor/vendor-Reviews";
  static const getMyKeyWord = "vendor/keywords";
  static const replyReview = "vendor/vendor-Reviews/add-reply?vendorId=";
  static const getStoreAnalytics = "vendor/store/analytics";
  static const getStoreEarning = "vendor/store/earnings";
  static const getSubscriptionPricing = "payments/subscription";
  static const getOrderId = "payments/order";
  static const requestCall = "vendor/request-call";
  static const getStoreRating = "vendor/vendor/store-rating";
  static const getSuccessfulTransactions = "payments/successfulTransactions";
  static const getProfileStatus = "vendor/profile-status/";
  static const getMissedLeads = "vendor/leads/missed";

  static const getNotifications = "notifications/getNotifications?userId=";
  static const notificationReadUpdate =
      "notifications/vendor/notificationReadUpdate";
  static const registerVendorFCMToken =
      "notifications/vendor/registerDeviceToken";
  static const createAadhaarCaptcha = "api/kyc/aadhaar/captcha?userId=";
  static const getAadhaarVerificationOTP = "kyc/v2/aadhaar/otp?uid_no=";
  static const verifyAadhaarOtp = "kyc/v2/aadhaar/validate/otp?otp=";
  static const verifykyc = "kyc/verifyKYC?type=";
  static const getQuotation = "vendor/requestedQuotation";
  static const getLeads = "vendor/leads";
  static const dateByGetLeads = "vendor/leads/active/date?";
  static const applyCoupon = "payments/applyDiscountCoupon";
  static const calculateFinalPrice = "payments/calculateFinalPrice";
  static const deListVendor = "vendor/deListVendor";
  static const getCredits = "payments/getCredits";

  static const SocialMediaApi = "auth/getAppSocialMediaHandles";

  static const redeemCredits = "payments/redeemReferralCode";
  static const verifyBusinessOnboardingRequestData =
      "vendor/verifyBusinessOnboardingRequestData";
  static const storeVerificationRequest =
      "vendor/vendor/store-verification-request";
}

class ArgumentConstant {
  static const AppVersion = "AppVersion";
  static const isFromQuotation = "isFromQuotation";
  static const photoModel = "photoModel";
  static const calenderDetails = "calenderDetails";
  static const kycTitle = "kycTitle";
  static const kycModel = "kycModel";
  static const index = "index";
  static const verifyUserName = "k-a5a8ec04-aaa4-446f-bd30-292061d2d1d1";
  static const verifyPassword = "s-c0802fdd-9708-4523-83d8-7e9f7d208994";
  static const session_id = "session_id";
  static const DRIVING_LICENCE = "DRIVING_LICENCE";
  static const PAN_CARD = "PAN_CARD";
  static const PASSPORT = "PASSPORT";
  static const VOTER_ID = "VOTER_ID";
  static const AADHAAR_CARD = "AADHAAR_CARD";
  static const userReview = "userReview";
  static const paymentModel = "paymentModel";
  static const url = "url";
  static String shareAppAndroid = (Platform.isIOS)
      ? "https://apps.apple.com/in/app/shadibazaar-business/id6478437683"
      : "https://play.google.com/store/apps/details?id=com.primezyventure.shaidbazaarvendor";
  static String shareApp =
      "Found the perfect customers on ShadiBazaar Business 🌟✨ Let others discover your amazing services too! Tap to share and expand your business reach! 💼🚀📲 Download ShadiBazaar Vendor App: $shareAppAndroid";
  static String shareVendor =
      "Hey there! 🌟 Just discovered an incredible vendor on ShadiBazaar with top-notch services. You should definitely check them out!👉 Vendor Here:$shareAppAndroid";
  static const contactUs =
      "https://d2ii5jq3v8tudi.cloudfront.net/contact-us.html";
  static const termsAndCondition =
      "https://www.termsfeed.com/live/4ecf677a-808a-4401-870c-64acaed55840";
  static const privacyPolicy =
      "https://www.termsfeed.com/live/9c30511a-5a4e-4518-98ba-30feddd090d7";
  static const appBarTitle = "appBarTitle";
}

class PrefStrings {
  static const userId = "userId";
  static const isUserLogin = "isUserLogin";
  static const phoneNumber = "phoneNumber";
  static const userData = "userData";
  static const city = "city";
  static const isDarkTheme = "isDarkTheme";
}

class NotificationConstant {
  static const All = "All";
  static const MARKETING = "MARKETING";
  static const PROMOTIONAL = "PROMOTIONAL";
  static const TRANSACTIONAL = "TRANSACTIONAL";
}

class AppConstant {
  static const basicDetails = "BASIC_DETAILS";
  static const servicePricingDetails = "SERVICE_PRICING_DETAILS";
  static const contactDetails = "CONTACT_DETAILS";
  static const kycDetails = "KYC_DETAILS";
  static const paymentDetails = "PAYMENT_DETAILS";
}

String getYoutubeThumbnail({required String videoId}) {
  return "https://img.youtube.com/vi/$videoId/hqdefault.jpg";
}
