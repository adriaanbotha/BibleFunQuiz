import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  final SettingsService settingsService;

  const SettingsScreen({Key? key, required this.settingsService}) 
      : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFFFF9800),
      ),
      body: ListView(
        children: [
          _buildSettingsSection('Game Settings', [
            _buildSwitch('Show Lives', 'show_lives'),
            _buildSwitch('Show Timer', 'show_timer'),
            _buildSwitch('Sound', 'sound_enabled'),
            _buildSwitch('Dark Theme', 'dark_theme'),
            _buildSwitch('Randomize Questions', 'randomize'),
            _buildSwitch('Offline Mode', 'offline_mode'),
          ]),
          _buildKidsModeSection(),
          _buildCategoriesSection(),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(title, 
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitch(String title, String prefKey) {
    return SwitchListTile(
      title: Text(title),
      value: widget.settingsService.getSetting(prefKey) ?? false,
      onChanged: (bool value) {
        setState(() {
          widget.settingsService.updateSetting(prefKey, value);
        });
      },
    );
  }

  Widget _buildKidsModeSection() {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _buildSwitch('Kids Mode', 'kids_mode'),
          if (widget.settingsService.kidsMode)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<String>(
                value: widget.settingsService.kidsAgeGroup,
                decoration: const InputDecoration(
                  labelText: 'Age Group',
                  border: OutlineInputBorder(),
                ),
                items: ['4-7', '8-11', '12+']
                    .map((age) => DropdownMenuItem(
                          value: age,
                          child: Text('Age $age'),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    widget.settingsService.updateSetting('kids_age_group', value);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Quiz Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          CheckboxListTile(
            title: const Text('Old Testament'),
            value: widget.settingsService.selectedCategories
                .contains('Old Testament'),
            onChanged: (bool? value) {
              _updateCategories('Old Testament', value ?? false);
            },
          ),
          CheckboxListTile(
            title: const Text('New Testament'),
            value: widget.settingsService.selectedCategories
                .contains('New Testament'),
            onChanged: (bool? value) {
              _updateCategories('New Testament', value ?? false);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Download questions functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9800),
                foregroundColor: Colors.white,
              ),
              child: const Text('Download Questions'),
            ),
          ),
        ],
      ),
    );
  }

  void _updateCategories(String category, bool selected) {
    final categories = List<String>.from(
        widget.settingsService.selectedCategories);
    if (selected) {
      categories.add(category);
    } else {
      categories.remove(category);
    }
    setState(() {
      widget.settingsService.updateSetting('selected_categories', categories);
    });
  }

  void _showPinSetupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Kids Mode PIN'),
        content: TextField(
          keyboardType: TextInputType.number,
          maxLength: 4,
          decoration: const InputDecoration(
            labelText: 'Enter 4-digit PIN',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            if (value.length == 4) {
              widget.settingsService.updateSetting('kids_pin', value);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFF9800),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
} 