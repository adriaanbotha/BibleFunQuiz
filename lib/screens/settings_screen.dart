import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../services/auth_service.dart';
import '../widgets/custom_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  final SettingsService settingsService;
  final AuthService? authService;

  const SettingsScreen({
    Key? key,
    required this.settingsService,
    this.authService,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _livesEnabled = true;
  int _numberOfLives = 5;
  bool _timerEnabled = true;
  int _timePerQuestion = 30;
  bool _showReferences = true;
  bool _randomizeQuestions = true;
  int _questionCount = 25;
  bool _isLoading = true;
  String? _selectedBibleBook;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);

    final soundEnabled = await widget.settingsService.getSoundEnabled();
    final livesEnabled = await widget.settingsService.getLivesEnabled();
    final numberOfLives = await widget.settingsService.getNumberOfLives();
    final timerEnabled = await widget.settingsService.getTimerEnabled();
    final timePerQuestion = await widget.settingsService.getTimePerQuestion();
    final showReferences = await widget.settingsService.getShowReferences();
    final randomizeQuestions = await widget.settingsService.getRandomizeQuestions();
    final questionCount = await widget.settingsService.getQuestionCount();
    final selectedBibleBook = await widget.settingsService.getSelectedBibleBook();

    setState(() {
      _soundEnabled = soundEnabled;
      _livesEnabled = livesEnabled;
      _numberOfLives = numberOfLives;
      _timerEnabled = timerEnabled;
      _timePerQuestion = timePerQuestion;
      _showReferences = showReferences;
      _randomizeQuestions = randomizeQuestions;
      _questionCount = questionCount;
      _selectedBibleBook = selectedBibleBook;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Settings',
        authService: widget.authService,
        settingsService: widget.settingsService,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // Sound Settings
                SwitchListTile(
                  title: const Text('Sound Effects'),
                  subtitle: const Text('Enable sound effects during quiz'),
                  value: _soundEnabled,
                  onChanged: (value) async {
                    await widget.settingsService.setSoundEnabled(value);
                    setState(() => _soundEnabled = value);
                  },
                ),
                const Divider(),

                // Lives Settings
                SwitchListTile(
                  title: const Text('Lives System'),
                  subtitle: const Text('Enable lives system during quiz'),
                  value: _livesEnabled,
                  onChanged: (value) async {
                    await widget.settingsService.setLivesEnabled(value);
                    setState(() => _livesEnabled = value);
                  },
                ),
                if (_livesEnabled)
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
                                  '$value ${value == 1 ? 'life' : 'lives'}',
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
                      ],
                    ),
                  ),
                const Divider(),

                // Timer Settings
                SwitchListTile(
                  title: const Text('Timer'),
                  subtitle: const Text('Enable timer during quiz'),
                  value: _timerEnabled,
                  onChanged: (value) async {
                    await widget.settingsService.setTimerEnabled(value);
                    setState(() => _timerEnabled = value);
                  },
                ),
                if (_timerEnabled)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                      ],
                    ),
                  ),
                const Divider(),

                // Reference Settings
                SwitchListTile(
                  title: const Text('Show References'),
                  subtitle: const Text('Show Bible references for answers'),
                  value: _showReferences,
                  onChanged: (value) async {
                    await widget.settingsService.setShowReferences(value);
                    setState(() => _showReferences = value);
                  },
                ),
                const Divider(),

                // Question Settings
                SwitchListTile(
                  title: const Text('Randomize Questions'),
                  subtitle: const Text('Shuffle questions during quiz'),
                  value: _randomizeQuestions,
                  onChanged: (value) async {
                    await widget.settingsService.setRandomizeQuestions(value);
                    setState(() => _randomizeQuestions = value);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Number of Questions',
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
                          value: _questionCount,
                          isExpanded: true,
                          underline: Container(),
                          items: [10, 25, 50, 100].map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(
                                '$value questions',
                                style: const TextStyle(fontSize: 16),
                              ),
                            );
                          }).toList(),
                          onChanged: (int? newValue) async {
                            if (newValue != null) {
                              await widget.settingsService.setQuestionCount(newValue);
                              setState(() {
                                _questionCount = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),

                // Bible Book Filter
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bible Book Filter',
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
                        child: DropdownButton<String?>(
                          value: _selectedBibleBook,
                          isExpanded: true,
                          underline: Container(),
                          hint: const Text('All Books'),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('All Books'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Genesis',
                              child: Text('Genesis'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Exodus',
                              child: Text('Exodus'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Leviticus',
                              child: Text('Leviticus'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Numbers',
                              child: Text('Numbers'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Deuteronomy',
                              child: Text('Deuteronomy'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Joshua',
                              child: Text('Joshua'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Judges',
                              child: Text('Judges'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Ruth',
                              child: Text('Ruth'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: '1 Samuel',
                              child: Text('1 Samuel'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: '2 Samuel',
                              child: Text('2 Samuel'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: '1 Kings',
                              child: Text('1 Kings'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: '2 Kings',
                              child: Text('2 Kings'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: '1 Chronicles',
                              child: Text('1 Chronicles'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: '2 Chronicles',
                              child: Text('2 Chronicles'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Ezra',
                              child: Text('Ezra'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Nehemiah',
                              child: Text('Nehemiah'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Esther',
                              child: Text('Esther'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Job',
                              child: Text('Job'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Psalms',
                              child: Text('Psalms'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Proverbs',
                              child: Text('Proverbs'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Ecclesiastes',
                              child: Text('Ecclesiastes'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Song of Solomon',
                              child: Text('Song of Solomon'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Isaiah',
                              child: Text('Isaiah'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Jeremiah',
                              child: Text('Jeremiah'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Lamentations',
                              child: Text('Lamentations'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Ezekiel',
                              child: Text('Ezekiel'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Daniel',
                              child: Text('Daniel'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Hosea',
                              child: Text('Hosea'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Joel',
                              child: Text('Joel'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Amos',
                              child: Text('Amos'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Obadiah',
                              child: Text('Obadiah'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Jonah',
                              child: Text('Jonah'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Micah',
                              child: Text('Micah'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Nahum',
                              child: Text('Nahum'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Habakkuk',
                              child: Text('Habakkuk'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Zephaniah',
                              child: Text('Zephaniah'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Haggai',
                              child: Text('Haggai'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Zechariah',
                              child: Text('Zechariah'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Malachi',
                              child: Text('Malachi'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Matthew',
                              child: Text('Matthew'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Mark',
                              child: Text('Mark'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Luke',
                              child: Text('Luke'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'John',
                              child: Text('John'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Acts',
                              child: Text('Acts'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Romans',
                              child: Text('Romans'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: '1 Corinthians',
                              child: Text('1 Corinthians'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: '2 Corinthians',
                              child: Text('2 Corinthians'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Galatians',
                              child: Text('Galatians'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Ephesians',
                              child: Text('Ephesians'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Philippians',
                              child: Text('Philippians'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Colossians',
                              child: Text('Colossians'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: '1 Thessalonians',
                              child: Text('1 Thessalonians'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: '2 Thessalonians',
                              child: Text('2 Thessalonians'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: '1 Timothy',
                              child: Text('1 Timothy'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: '2 Timothy',
                              child: Text('2 Timothy'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Titus',
                              child: Text('Titus'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Philemon',
                              child: Text('Philemon'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Hebrews',
                              child: Text('Hebrews'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'James',
                              child: Text('James'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: '1 Peter',
                              child: Text('1 Peter'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: '2 Peter',
                              child: Text('2 Peter'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: '1 John',
                              child: Text('1 John'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: '2 John',
                              child: Text('2 John'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: '3 John',
                              child: Text('3 John'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Jude',
                              child: Text('Jude'),
                            ),
                            const DropdownMenuItem<String?>(
                              value: 'Revelation',
                              child: Text('Revelation'),
                            ),
                          ],
                          onChanged: (String? newValue) async {
                            if (newValue != _selectedBibleBook) {
                              await widget.settingsService.setSelectedBibleBook(newValue);
                              setState(() {
                                _selectedBibleBook = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),

                // Reset Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Reset Settings'),
                          content: const Text('Are you sure you want to reset all settings to defaults?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Reset'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await widget.settingsService.resetToDefaults();
                        await _loadSettings();
                      }
                    },
                    child: const Text('Reset to Defaults'),
                  ),
                ),
              ],
            ),
    );
  }
} 