import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utilities/avatar_utility.dart';

class AvatarSelector extends StatefulWidget {
  final AuthService authService;
  final String currentAvatar;
  final Function(String) onAvatarSelected;

  const AvatarSelector({
    Key? key,
    required this.authService,
    required this.currentAvatar,
    required this.onAvatarSelected,
  }) : super(key: key);

  @override
  State<AvatarSelector> createState() => _AvatarSelectorState();
}

class _AvatarSelectorState extends State<AvatarSelector> {
  late String _selectedAvatar;
  
  @override
  void initState() {
    super.initState();
    _selectedAvatar = widget.currentAvatar;
  }
  
  @override
  Widget build(BuildContext context) {
    final avatarOptions = widget.authService.getAvatarOptions();
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose Your Biblical Character',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9800),
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: avatarOptions.length,
                itemBuilder: (context, index) {
                  final avatar = avatarOptions[index];
                  final isSelected = _selectedAvatar == avatar;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAvatar = avatar;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AvatarUtility.getAvatarColor(avatar).withOpacity(0.3)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected 
                              ? AvatarUtility.getAvatarColor(avatar)
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AvatarUtility.getAvatarColor(avatar).withOpacity(0.2),
                            child: ClipOval(
                              child: Image.asset(
                                AvatarUtility.getAvatarPath(avatar),
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    AvatarUtility.getAvatarFallbackIcon(avatar),
                                    size: 36,
                                    color: AvatarUtility.getAvatarColor(avatar),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AvatarUtility.getAvatarName(avatar),
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedAvatar.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  AvatarUtility.getAvatarDescription(_selectedAvatar),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                  ),
                  onPressed: () {
                    widget.onAvatarSelected(_selectedAvatar);
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Select',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 