import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:provider/provider.dart';

class AuthBloc {
  final _authService = AuthService();

  final fb = FacebookLogin();

  Stream<User> get currentUser => _authService.currentUser;

  loginFacebook() async {
    print('Starting  Facebook Login');

    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);

    switch (res.status) {
      case FacebookLoginStatus.success:
        print('It worked');

//Get Token
        final FacebookAccessToken fbToken = res.accessToken;

        // Convert to Auth Credential
        final AuthCredential credential =
            FacebookAuthProvider.credential(fbToken.token);

        //User Credential to sign in with Firebase

        final result = await _authService.signInWithCredential(credential);

        print('${result.user.displayName} is now logged in');
        break;
      case FacebookLoginStatus.cancel:
        print('The user cancelled the login');
        break;
      case FacebookLoginStatus.error:
        print('There was an error');
        break;
    }
  }

  logout() {
    _authService.logout();
  }
}
