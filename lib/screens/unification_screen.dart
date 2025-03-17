import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../theme/theme.dart';

class UnificationScreen extends StatelessWidget {
  const UnificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Unification of the Church'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Unity in Christ',
              style: AppTheme.titleStyle,
            ),
            const SizedBox(height: 16),
            Text(
              'In this critical hour, God is calling His church to stand united as one body in Christ. The world faces unprecedented challenges, and the church must be a beacon of light and hope.',
              style: AppTheme.bodyStyle,
            ),
            const SizedBox(height: 24),
            Text(
              'The Call to Unity',
              style: AppTheme.subtitleStyle,
            ),
            const SizedBox(height: 16),
            Text(
              '"I appeal to you, brothers and sisters, in the name of our Lord Jesus Christ, that all of you agree with one another in what you say and that there be no divisions among you, but that you be perfectly united in mind and thought." - 1 Corinthians 1:10',
              style: AppTheme.bodyStyle.copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),
            Text(
              'Standing Together',
              style: AppTheme.subtitleStyle,
            ),
            const SizedBox(height: 16),
            Text(
              'As the forces of darkness grow stronger, the Church must:\n\n'
              '• Unite in prayer and intercession\n'
              '• Set aside denominational differences\n'
              '• Focus on our common faith in Christ\n'
              '• Support and encourage one another\n'
              '• Stand firm against evil and corruption\n'
              '• Share resources and strengthen each other\n'
              '• Show the world the power of Christian love and unity',
              style: AppTheme.bodyStyle,
            ),
            const SizedBox(height: 24),
            Text(
              'The Power of Unity',
              style: AppTheme.subtitleStyle,
            ),
            const SizedBox(height: 16),
            Text(
              '"How good and pleasant it is when God\'s people live together in unity!" - Psalm 133:1\n\n'
              'When we stand together as one body:\n\n'
              '• Our witness becomes stronger\n'
              '• Our prayers become more powerful\n'
              '• Our impact on society increases\n'
              '• We reflect Christ\'s love more clearly\n'
              '• We overcome evil with good\n'
              '• We demonstrate God\'s kingdom on earth',
              style: AppTheme.bodyStyle,
            ),
            const SizedBox(height: 24),
            Text(
              'Taking Action',
              style: AppTheme.subtitleStyle,
            ),
            const SizedBox(height: 16),
            Text(
              'Let us commit to:\n\n'
              '• Pray for unity in the global Church\n'
              '• Reach out to other believers and congregations\n'
              '• Focus on what unites us rather than what divides us\n'
              '• Work together for the kingdom of God\n'
              '• Support Christian initiatives across denominations\n'
              '• Show the world that we are one in Christ',
              style: AppTheme.bodyStyle,
            ),
          ],
        ),
      ),
    );
  }
} 