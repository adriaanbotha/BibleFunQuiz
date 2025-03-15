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
  bool _showReferences = true;
  int _questionsPerQuiz = 10;
  bool _soundEnabled = true;
  bool _livesEnabled = true;
  int _numberOfLives = 3;
  int _timePerQuestion = 30;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final soundEnabled = await widget.settingsService.getSoundEnabled();
    final livesEnabled = await widget.settingsService.getLivesEnabled();
    final numberOfLives = await widget.settingsService.getNumberOfLives();
    final timePerQuestion = await widget.settingsService.getTimePerQuestion();
    
    setState(() {
      _soundEnabled = soundEnabled;
      _livesEnabled = livesEnabled;
      _numberOfLives = numberOfLives;
      _timePerQuestion = timePerQuestion;
    });
  }

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
            Switch(
              value: _showReferences,
              onChanged: (value) async {
                await widget.settingsService.setShowReferences(value);
                setState(() => _showReferences = value);
              },
            ),
            DropdownButton<int>(
              value: _questionsPerQuiz,
              items: [5, 10, 15, 20].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value questions'),
                );
              }).toList(),
              onChanged: (int? newValue) async {
                if (newValue != null) {
                  await widget.settingsService.setQuestionsPerQuiz(newValue);
                  setState(() => _questionsPerQuiz = newValue);
                }
              },
            ),
          ]),
          _buildKidsModeSection(),
          _buildCategoriesSection(),
          SwitchListTile(
            title: const Text('Sound Effects'),
            subtitle: const Text('Play sounds for correct/incorrect answers'),
            value: _soundEnabled,
            onChanged: (bool value) async {
              await widget.settingsService.setSoundEnabled(value);
              setState(() {
                _soundEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Lives System'),
            subtitle: const Text('Enable lives system in quiz'),
            value: _livesEnabled,
            onChanged: (bool value) async {
              await widget.settingsService.setLivesEnabled(value);
              setState(() {
                _livesEnabled = value;
              });
            },
          ),
          if (_livesEnabled) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Number of Lives',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton<int>(
                      value: _numberOfLives,
                      isExpanded: true,
                      underline: Container(),
                      items: [1, 2, 3, 4, 5].map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(
                            value == 1 ? '$value Life' : '$value Lives',
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                      onChanged: (int? newValue) async {
                        if (newValue != null) {
                          await widget.settingsService.setNumberOfLives(newValue);
                          setState(() {
                            _numberOfLives = newValue;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Select how many lives you start with in each quiz',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Time per Question',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButton<int>(
                    value: _timePerQuestion,
                    isExpanded: true,
                    underline: Container(),
                    items: [15, 20, 30, 45, 60].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          '$value seconds',
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                    onChanged: (int? newValue) async {
                      if (newValue != null) {
                        await widget.settingsService.setTimePerQuestion(newValue);
                        setState(() {
                          _timePerQuestion = newValue;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Set the time limit for each question',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
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