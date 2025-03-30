import 'package:flutter/material.dart';

class AvatarUtility {
  // Get the asset path for an avatar
  static String getAvatarPath(String avatar) {
    return 'assets/images/avatars/$avatar.png';
  }
  
  // Get a descriptive name for the avatar
  static String getAvatarName(String avatar) {
    switch (avatar) {
      case 'noah':
        return 'Noah';
      case 'moses':
        return 'Moses';
      case 'david':
        return 'King David';
      case 'daniel':
        return 'Daniel';
      case 'esther':
        return 'Queen Esther';
      case 'ruth':
        return 'Ruth';
      case 'abraham':
        return 'Abraham';
      case 'joshua':
        return 'Joshua';
      case 'solomon':
        return 'King Solomon';
      case 'samson':
        return 'Samson';
      case 'deborah':
        return 'Deborah';
      case 'miriam':
        return 'Miriam';
      default:
        return 'Unknown';
    }
  }
  
  // Get a short description for each biblical character
  static String getAvatarDescription(String avatar) {
    switch (avatar) {
      case 'noah':
        return 'Built the ark to save animals from the flood';
      case 'moses':
        return 'Led the Israelites out of Egypt';
      case 'david':
        return 'Shepherd boy who became king of Israel';
      case 'daniel':
        return 'Survived the lions\' den';
      case 'esther':
        return 'Queen who saved her people';
      case 'ruth':
        return 'Loyal and devoted daughter-in-law';
      case 'abraham':
        return 'Father of many nations';
      case 'joshua':
        return 'Led Israel to the Promised Land';
      case 'solomon':
        return 'Known for his wisdom and wealth';
      case 'samson':
        return 'Had incredible strength from God';
      case 'deborah':
        return 'Prophet and judge of Israel';
      case 'miriam':
        return 'Sister of Moses and Aaron';
      default:
        return '';
    }
  }
  
  // Get a color associated with this avatar for UI elements
  static Color getAvatarColor(String avatar) {
    switch (avatar) {
      case 'noah':
        return Colors.blue;
      case 'moses':
        return Colors.red;
      case 'david':
        return Colors.purple;
      case 'daniel':
        return Colors.amber;
      case 'esther':
        return Colors.pink;
      case 'ruth':
        return Colors.green;
      case 'abraham':
        return Colors.brown;
      case 'joshua':
        return Colors.orange;
      case 'solomon':
        return Colors.indigo;
      case 'samson':
        return Colors.deepOrange;
      case 'deborah':
        return Colors.teal;
      case 'miriam':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }
  
  // Fallback icon to use if the avatar image is not found
  static IconData getAvatarFallbackIcon(String avatar) {
    switch (avatar) {
      case 'noah':
        return Icons.waves;
      case 'moses':
        return Icons.article;
      case 'david':
        return Icons.music_note;
      case 'daniel':
        return Icons.pets;
      case 'esther':
        return Icons.star;
      case 'ruth':
        return Icons.grass;
      case 'abraham':
        return Icons.person;
      case 'joshua':
        return Icons.military_tech;
      case 'solomon':
        return Icons.temple_buddhist;
      case 'samson':
        return Icons.fitness_center;
      case 'deborah':
        return Icons.gavel;
      case 'miriam':
        return Icons.music_note;
      default:
        return Icons.person;
    }
  }
} 