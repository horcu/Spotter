import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    return const Text('Icon made by Pixel perfect from www.flaticon.com',
      style: TextStyle(fontSize: 8, fontStyle: FontStyle.italic),);
  }
}
