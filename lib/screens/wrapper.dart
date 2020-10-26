import 'package:flutter/material.dart';
import 'package:goat_app/screens/login/login_page.dart';
import 'package:goat_app/screens/posts/post_page.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

/*This class handles if the app should show the Login page or Home Page 
depending on if the user is logged in or not.  Once the user is authenticated
it also loads the users profile before continuing to the home page.*/
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    /*This should in most cases handles if the user is logged in or not.
    In some cases Auth state chanegs can be slow to react so this logic may
    apear in other sections */
    if (user == null) {
      return LoginPage();
    } else {
      return PostPage();
    }
  }
}
