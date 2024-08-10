import 'package:flutter/material.dart';


class Popupform extends StatefulWidget {
  const Popupform({super.key});

  @override
  State<Popupform> createState() => _PopupformState();
}

class _PopupformState extends State<Popupform> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    return ElevatedButton(
      child: Text("Open Popup"),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                scrollable: true,
                title: Text('Login'),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Name',
                            icon: Icon(Icons.account_box),
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            icon: Icon(Icons.email),
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Message',
                            icon: Icon(Icons.message ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                      child: Text("Submit"),
                      onPressed: () {
                        // your code
                      })
                ],
              );
            });
      },
    );
  }
}