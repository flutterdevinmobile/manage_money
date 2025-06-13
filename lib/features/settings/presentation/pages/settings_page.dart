import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../inject.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../data_management/presentation/bloc/data_management_bloc.dart';
import '../../../data_management/presentation/bloc/data_management_event.dart';
import '../../../data_management/presentation/bloc/data_management_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DataManagementBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.settings),
        ),
        body: BlocListener<DataManagementBloc, DataManagementState>(
          listener: (context, state) {
            if (state is DataManagementSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is DataManagementError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return _buildSettingsContent(context, state.user.id);
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsContent(BuildContext context, String userId) {
    return ListView(
      children: [
        // Profile Section
        Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // CircleAvatar(
                //   radius: 40,
                //   backgroundImage:
                //   context.read<AuthBloc>().state is AuthAuthenticated
                //       ? (context.read<AuthBloc>().state as AuthAuthenticated)
                //       .user
                //       .photoUrl !=
                //       null
                //       ? NetworkImage((context.read<AuthBloc>().state
                //   as AuthAuthenticated)
                //       .user
                //       .photoUrl!)
                //       : null
                //       : null,
                //   child: context.read<AuthBloc>().state is AuthAuthenticated
                //       ? (context.read<AuthBloc>().state as AuthAuthenticated)
                //       .user
                //       .photoUrl ==
                //       null
                //       ? const Icon(Icons.person, size: 40)
                //       : null
                //       : null,
                // ),
                // const SizedBox(height: 16),
                // Text(
                //   context.read<AuthBloc>().state is AuthAuthenticated
                //       ? (context.read<AuthBloc>().state as AuthAuthenticated)
                //       .user
                //       .displayName ??
                //       'Foydalanuvchi'
                //       : 'Foydalanuvchi',
                //   style: const TextStyle(
                //     fontSize: 20,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const SizedBox(height: 8),
                Text(
                  context.read<AuthBloc>().state is AuthAuthenticated
                      ? (context.read<AuthBloc>().state as AuthAuthenticated)
                          .user
                          .email
                      : 'email',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Settings Options
        _buildSettingsSection(
          'Umumiy',
          [
            _buildSettingsTile(
              icon: Icons.language,
              title: AppStrings.language,
              subtitle: 'O\'zbekcha',
              onTap: () => _showLanguageDialog(context),
            ),
            _buildSettingsTile(
              icon: Icons.dark_mode,
              title: AppStrings.theme,
              subtitle: 'Tizim bo\'yicha',
              onTap: () => _showThemeDialog(context),
            ),
            _buildSettingsTile(
              icon: Icons.notifications,
              title: 'Bildirishnomalar',
              subtitle: 'Yoqilgan',
              onTap: () {},
            ),
          ],
        ),

        _buildSettingsSection(
          'Ma\'lumotlar',
          [
            BlocBuilder<DataManagementBloc, DataManagementState>(
              builder: (context, state) {
                return _buildSettingsTile(
                  icon: Icons.backup,
                  title: 'Ma\'lumotlarni zaxiralash',
                  subtitle: 'Cloud\'ga zaxiralash',
                  onTap: state is DataManagementLoading
                      ? () {} // Bo'sh function o'rniga
                      : () => _createBackup(context, userId),
                );
              },
            ),
            _buildSettingsTile(
              icon: Icons.download,
              title: 'Xarajatlarni eksport qilish',
              subtitle: 'CSV formatida yuklab olish',
              onTap: () => _exportData(context, userId, 'expenses'),
            ),
            _buildSettingsTile(
              icon: Icons.download,
              title: 'Qarzlarni eksport qilish',
              subtitle: 'CSV formatida yuklab olish',
              onTap: () => _exportData(context, userId, 'loans'),
            ),
            _buildSettingsTile(
              icon: Icons.download,
              title: 'Budgetlarni eksport qilish',
              subtitle: 'CSV formatida yuklab olish',
              onTap: () => _exportData(context, userId, 'budgets'),
            ),
            _buildSettingsTile(
              icon: Icons.download,
              title: 'Maqsadlarni eksport qilish',
              subtitle: 'CSV formatida yuklab olish',
              onTap: () => _exportData(context, userId, 'goals'),
            ),
            _buildSettingsTile(
              icon: Icons.delete_forever,
              title: 'Ma\'lumotlarni o\'chirish',
              subtitle: 'Barcha ma\'lumotlarni o\'chirish',
              onTap: () => _showDeleteDataDialog(context, userId),
              textColor: Colors.red,
            ),
          ],
        ),

        _buildSettingsSection(
          'Yordam',
          [
            _buildSettingsTile(
              icon: Icons.help,
              title: 'Yordam',
              subtitle: 'FAQ va qo\'llanma',
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.feedback,
              title: 'Fikr bildirish',
              subtitle: 'Ilovani yaxshilashga yordam bering',
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.info,
              title: 'Ilova haqida',
              subtitle: 'Versiya 1.0.0',
              onTap: () => _showAboutDialog(context),
            ),
          ],
        ),

        // Logout Button
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () => _showLogoutDialog(context),
            icon: const Icon(Icons.logout),
            label: const Text(AppStrings.logout),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap, // ? qo'shing
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap, // Bu endi nullable bo'ladi
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tilni tanlang'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('O\'zbekcha'),
              value: 'uz',
              groupValue: 'uz',
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<String>(
              title: const Text('Русский'),
              value: 'ru',
              groupValue: 'uz',
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: 'uz',
              onChanged: (value) => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mavzuni tanlang'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Yorug\''),
              value: 'light',
              groupValue: 'system',
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<String>(
              title: const Text('Qorong\'u'),
              value: 'dark',
              groupValue: 'system',
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<String>(
              title: const Text('Tizim bo\'yicha'),
              value: 'system',
              groupValue: 'system',
              onChanged: (value) => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _createBackup(BuildContext context, String userId) {
    context.read<DataManagementBloc>().add(
          BackupCreateRequested(userId: userId),
        );
  }

  void _exportData(BuildContext context, String userId, String dataType) {
    context.read<DataManagementBloc>().add(
          DataExportRequested(userId: userId, dataType: dataType),
        );
  }

  void _showDeleteDataDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ma\'lumotlarni o\'chirish'),
        content: const Text(
          'Haqiqatan ham barcha ma\'lumotlarni o\'chirmoqchimisiz? Bu amalni bekor qilib bo\'lmaydi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor qilish'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<DataManagementBloc>().add(
                    DataDeleteRequested(userId: userId),
                  );
            },
            child: const Text(
              'O\'chirish',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppStrings.appName,
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.account_balance_wallet),
      children: [
        const Text(
          'Manage My Money - bu shaxsiy moliyaviy boshqaruv ilovasi. '
          'Xarajatlaringizni kuzatib boring, qarzlaringizni boshqaring va '
          'moliyaviy maqsadlaringizga erishing.',
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chiqish'),
        content: const Text('Haqiqatan ham tizimdan chiqmoqchimisiz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor qilish'),
          ),
          TextButton(
            onPressed: () {
              context.go('/sign-in');
              context.read<AuthBloc>().add(AuthSignOutRequested());
            },
            child: const Text('Chiqish'),
          ),
        ],
      ),
    );
  }
}
