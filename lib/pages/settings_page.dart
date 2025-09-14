import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            
            Card(
              child: ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notifications'),
                subtitle: Text('Manage event notifications'),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // Handle notification toggle
                  },
                ),
              ),
            ),
            
            Card(
              child: ListTile(
                leading: Icon(Icons.color_lens),
                title: Text('Theme'),
                subtitle: Text('Choose app theme'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Handle theme selection
                },
              ),
            ),
            
            Card(
              child: ListTile(
                leading: Icon(Icons.info),
                title: Text('About'),
                subtitle: Text('App version and info'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Handle about page
                },
              ),
            ),
            
            SizedBox(height: 40),
            
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to previous page
              },
              child: Text('Back to Calendar'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}