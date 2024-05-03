import 'package:flutter/material.dart';

class FormP extends StatefulWidget {
  const FormP({super.key});

  @override
  State<FormP> createState() => _FormPState();
}

class _FormPState extends State<FormP> {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String ?_name;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter your name',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your name';
                }
                return null; // Return null if the input is valid
              },
              onSaved: (value) {
                _name = value;
              },
            ),
            SizedBox(height: 20.0),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Do something with the validated data, for example, save it to a database
                
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
