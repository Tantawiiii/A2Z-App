class ApiConstants {

  //static const String apiBaseUrl = "http://a2zplatform.com";
  // static const String apiBaseUrl = "http://edu.a2zplatform.com";
  static const String apiBaseUrl = "http://centera2z.com";
  //static const String apiBaseUrlGraphQl = "http://edu.a2zplatform.com/graphql";
  static const String apiBaseUrlGraphQl = "http://centera2z.com/graphql";

  static String apiRequestPasswordRest(String loginOrEmail) => "$apiBaseUrl/api/platform/security/users/$loginOrEmail/requestpasswordreset/";
  static String apiChangePasswordByOTP = "$apiBaseUrl/api/platform/security/users/ChangePasswordByOTP";
  static String apiLogin = "$apiBaseUrl/connect/token";
  static String apiChangePassword = "$apiBaseUrl/api/platform/security/currentuser/changepassword";
  static String apiGetBanners = "$apiBaseUrl/api/marketing/GetBannars";

  static String apiSubscriptionByCode = "$apiBaseUrl/api/Subscriptions/SubscripeByCode";
  static String apiCheckStudentSubscription = "$apiBaseUrl/api/Subscriptions/CheckStudentSubscription";

}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}