import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationEnabled = true;
  int _selectedThemeIndex = 0;
  int _selectedLanguageIndex = 0;
  final List<String> _themes = [
    'Light',
    'Dark',
  ];
  final List<String> _languages = [
    'Arabic',
    'English',
  ];

  // Function to switch the theme based on the selected index
  void _switchTheme(int? index) {
    setState(() {
      _selectedThemeIndex = index!;
    });

    // You can define your own logic to set the theme based on the selected index
    if (index == 0) {
      // Set light theme
      _setLightTheme();
    } else if (index == 1) {
      // Set dark theme
      _setDarkTheme();
    }
  }

  // Example function to set the light theme
  void _setLightTheme() {
    // Replace this with your own logic to set the light theme
    // You can use the 'theme' property of the MaterialApp widget or any other approach
    print('Light theme selected');
  }

  // Example function to set the dark theme
  void _setDarkTheme() {
    // Replace this with your own logic to set the dark theme
    // You can use the 'theme' property of the MaterialApp widget or any other approach
    print('Dark theme selected');
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the currently selected theme based on the index
    final ThemeData selectedTheme =
        _selectedThemeIndex == 0 ? ThemeData.light() : ThemeData.dark();

    return Theme(
      data: selectedTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: _notificationEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationEnabled = value;
                });
              },
            ),
            ListTile(
              title: const Text('Theme'),
              trailing: DropdownButton<int>(
                value: _selectedThemeIndex,
                items: _themes.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final String theme = entry.value;
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text(theme),
                  );
                }).toList(),
                onChanged: _switchTheme, // Call the switchTheme function
              ),
            ),
            ListTile(
              title: const Text('Language'),
              trailing: DropdownButton<int>(
                value: _selectedLanguageIndex,
                items: _languages.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final String language = entry.value;
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text(language),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLanguageIndex = value!;
                  });
                },
              ),
            ),
            // Add more settings here
          ],
        ),
      ),
    );
  }
}
