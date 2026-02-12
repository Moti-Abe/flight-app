import 'package:flutter/material.dart';

class ConnectedDevicesPage extends StatelessWidget {
  const ConnectedDevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connected Devices")),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.phone_android),
            title: Text("Samsung Galaxy S23"),
            subtitle: Text("Last active: Today"),
          ),
          ListTile(
            leading: Icon(Icons.laptop),
            title: Text("Chrome on Windows"),
            subtitle: Text("Last active: Yesterday"),
          ),
        ],
      ),
    );
  }
}
