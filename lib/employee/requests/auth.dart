import "../googleapi/auth.dart";
import "../utilities/localStorage.dart" as localStorage;

Future<bool> logout() async {
  try {
    await logoutFromGoogle();
    await localStorage.removeFromLocalStorage("x-auth-token");
    await localStorage.removeFromLocalStorage("remember");
    await localStorage.removeFromLocalStorage("admin");
    await localStorage.removeFromLocalStorage("referral_token");
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}
