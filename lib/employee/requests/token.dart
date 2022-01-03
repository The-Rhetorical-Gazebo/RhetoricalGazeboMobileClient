import "../utilities/localStorage.dart" as localStorage;

Future<String?> getAdminReferralToken() async {
  try {
    return await localStorage.readFromLocalStorage("referral_token");
  } catch (err) {
    return null;
  }
}
