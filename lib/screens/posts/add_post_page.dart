import 'package:flutter/material.dart';
import 'package:goat_app/services/database.dart';
import '../../models/post.dart';
import '../../models/user.dart';

class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isValid = false;
  bool _isLoading = false;
  bool isEdit = false;
  Map args;
  Post post;
  UserData user;
  var postContent = '';

  @override
  void didChangeDependencies() {
    args = ModalRoute.of(context).settings.arguments as Map;
    user = args['user'] as UserData;

    if (args['post'] != null) {
      setState(() {
        isEdit = true;
        post = args['post'] as Post;
        print(post.id);
        postContent = post.content;
      });
    }

    super.didChangeDependencies();
  }

  void _saveForm(context) async {
    setState(() => _isLoading = true);

    _formKey.currentState.save(); //Save Form

    if (isEdit) {
      try {
        DatabaseService().updatePost(post.id, postContent);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("An Error Occured"),
            content: Text("Something went Wrong"),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        );
      }
    } else {
      try {
        DatabaseService().addPost(user, postContent, DateTime.now());
      } catch (error) {
        print(error);
        await showDialog<Null>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("An Error Occured"),
            content: Text("Something went Wrong"),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        );
      }
    }

    setState(() => _isLoading = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.clear, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        textTheme:
            TextTheme(headline6: TextStyle(color: Colors.black, fontSize: 18)),
        title: isEdit ? Text('Edit Post') : Text("New Post"),
        centerTitle: true,
        actions: [
          FlatButton(
            child: Text(
              'Post',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: _isValid ? () => _saveForm(context) : null,
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Center(
          child: _isLoading
              ? CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            hintText: "Insert your message",
                          ),
                          scrollPadding: EdgeInsets.all(20.0),
                          keyboardType: TextInputType.multiline,
                          maxLines: 99999,
                          autofocus: true,
                          initialValue: postContent,
                          onChanged: (value) => setState(() {
                            value.trim().isNotEmpty
                                ? _isValid = true
                                : _isValid = false;
                          }),
                          onSaved: (value) => postContent = value,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
      resizeToAvoidBottomPadding: true,
    );
  }
}
