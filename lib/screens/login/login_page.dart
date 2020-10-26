import 'package:flutter/material.dart';
import 'package:goat_app/models/user.dart';
import 'package:provider/provider.dart';
import '../../services/auth.dart';

enum AuthMode { Signup, Login }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  //Manage changes to the state
  bool _isLoading = false;
  bool _showRegister = false;
  bool _loginFailed = false;
  String _warningText = '';
  String snackBarText = '';

  //Fields for the form.
  UserData _user = new UserData();
  String _password;

  void _submit(context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    FocusScope.of(context).unfocus();

    setState(() {
      _loginFailed = false;
      _isLoading = true;
    });

    if (_showRegister) {
      try {
        await AuthService().registerWithEmailAndPassword(_user, _password);
      } catch (error) {
        print('error here');
        print(error);
        switch (error) {
          case "email-already-in-use":
            _warningText = "A user is already registered with this email";
            break;
          case "invalid-email":
            _warningText = "Please ensure all fields have been completed";
            break;
          case "operation-not-allowed":
            _warningText = "Sorry, You can't create a user at this time";
            break;
          default:
            _warningText = "Error! Something Went Wrong.";
            break;
        }
        /*Handle any error code from failed logins. Register function passes 
        errors back to where it is called from */
        setState(() {
          _loginFailed = true;
          _isLoading = false;
        });
      }
    } else {
      try {
        await AuthService().signInWithEmailAndPassword(_user.email, _password);
      } catch (error) {
        print(error);
        /*Login function passes any errors back to where it is called from
        Handle the text that will be displayed on screen depending on the
        Type of error */
        switch (error) {
          case "invalid-email":
          case "user-not-found":
            _warningText = "Invalid Email Address";
            break;
          case "wrong-password":
            _warningText = "Invalid Password";
            break;
          case "too-many-requests":
            _warningText = "Maximum Login Attempts Exceeded.";
            break;
          case "user-disabled:":
          default:
            _warningText = "Sorry! Something Went Wrong.";
        }

        setState(() {
          _loginFailed = true;
          _isLoading = false;
        });
      }
    }
  }

  void _forgotPassword(context) async {
    snackBarText = "Please check your emails to reset password";
    _formKey.currentState.save();

    if (_user.email.trim() == '') {
      setState(() {
        _warningText = "Please Enter your email";
        _loginFailed = true;
      });
    } else {
      FocusScope.of(context).unfocus();
      try {
        await AuthService().resetPassword(_user.email);
      } catch (error) {
        if (error == 'user-not-found') {
          snackBarText = 'No User Found With This Email Address.';
        } else {
          snackBarText = 'An Error has occured, Try again.';
        }
      } finally {
        final snack = SnackBar(content: Text(snackBarText));
        Scaffold.of(context).showSnackBar(snack);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.10),
            margin: EdgeInsets.only(top: deviceSize.height * 0.10),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (_showRegister)
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(labelText: 'Name'),
                        autofocus: _showRegister,
                        validator: (value) {
                          if (_showRegister && value.isEmpty) {
                            return 'Can not be empty!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _user.name = value.trim();
                        },
                      ),
                    SizedBox(height: 10),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      autofocus: !_showRegister,
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Invalid email!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _user.email = value.trim();
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onChanged: (value) {
                        _password = value;
                      },
                      validator: (value) {
                        if (value.isEmpty || value.length < 5) {
                          _password = value;
                          return 'Password is too short!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value;
                      },
                    ),
                    SizedBox(height: 10),
                    if (_showRegister)
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: (value) {
                          if (_showRegister && value != _password) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    if (_loginFailed)
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            _warningText,
                            style:
                                TextStyle(color: Theme.of(context).errorColor),
                          )),
                    _isLoading
                        ? Padding(
                            padding: const EdgeInsets.all(10),
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            children: [
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(top: 10),
                                child: RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () => _submit(context),
                                  child: Text(
                                    _showRegister ? "Register" : "Log In",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              _showRegister
                                  ? FlatButton(
                                      child: Text(
                                          "Already have an account? Log In"),
                                      onPressed: () => setState(() {
                                        _loginFailed = false;
                                        _showRegister = false;
                                      }),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        FlatButton(
                                          child: Text("Register Now!"),
                                          onPressed: () => setState(() {
                                            _loginFailed = false;
                                            _showRegister = true;
                                          }),
                                        ),
                                        FlatButton(
                                          child: Text('Forgot Password?'),
                                          onPressed: () {
                                            _forgotPassword(context);
                                          },
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
