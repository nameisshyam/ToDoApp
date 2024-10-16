import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../providers/user_screen_provider.dart';


class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : const AssetImage('assets/avatar.jpg'),  // Use AssetImage as default
                    child: _imageFile == null
                        ? null // No need to display anything inside, since the AssetImage will be used
                        : null,
                  ),
                ),
                TextButton(onPressed: _pickImage, child: const Text("Add Picture",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),)),
                const SizedBox(height: 20),
                TextFormField(
                  cursorColor: Colors.blue,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.normal),
                    focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue,width: 2),
                  ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    } else if (value.length < 2){
                      return 'Please enter a name more than 2 characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  cursorColor: Colors.blue,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.normal),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if(!value.contains('@')){
                      return 'Please enter valid email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      String? profileImagePath = _imageFile?.path ?? 'assets/avatar.jpg';
                      Provider.of<UserProvider>(context, listen: false)
                          .updateUser(_name, _email, profileImagePath);
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  },
                  child: const Text('Save Profile',style: TextStyle(color: Colors.blue),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
